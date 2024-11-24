from datetime import datetime

from flask import Flask, render_template, request, redirect, url_for, flash
import sqlalchemy
from sqlalchemy import func
from sqlalchemy.orm import aliased

from engine import engine
from models import db, Applicants, Applications, Department, Group, Faculty, EventTypes, Stream, Event, ExamResults

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = engine
app.secret_key = 'secret'

db.init_app(app)


def update_model_from_form(model_instance, form_data):
    """
    Updates all fields of a given SQLAlchemy model instance except for its primary key fields,
    using the data provided in form_data (e.g., request.form).

    Args:
        model_instance: The SQLAlchemy model instance to update.
        form_data: A dictionary-like object (e.g., request.form) containing the new field values.

    Returns:
        None
    """
    model_class = type(model_instance)
    primary_keys = {key.name for key in model_class.__mapper__.primary_key}

    for key, value in form_data.items():
        if key in primary_keys:
            continue

        if hasattr(model_instance, key):
            column_type = model_class.__mapper__.columns[key].type
            if not value:
                value = None
            else:
                if isinstance(column_type, sqlalchemy.types.Boolean):
                    value = value.lower() in ['true', '1', 'yes', 'on']
            setattr(model_instance, key, value)
    return model_class


def populate_model_from_form(model_instance, form_data):
    """
    Populates a given SQLAlchemy model instance with data from a form.

    Args:
        model_instance: The SQLAlchemy model instance to populate.
        form_data: A dictionary-like object (e.g., request.form) containing the field values.

    Returns:
        None
    """
    model_class = type(model_instance)

    for key, value in form_data.items():
        if hasattr(model_instance, key):
            column_type = model_class.__mapper__.columns[key].type
            if not value:
                value = None
            else:
                if isinstance(column_type, sqlalchemy.types.Boolean):
                    value = value.lower() in ['true', '1', 'yes', 'on']
                if isinstance(column_type, sqlalchemy.types.Double):
                    value = float(value)
                elif isinstance(column_type, sqlalchemy.types.Date):
                    try:
                        value = datetime.strptime(value, '%Y-%m-%d').date() if value else None
                    except ValueError:
                        raise ValueError(f"Invalid date format for {key}, expected YYYY-MM-DD")
            setattr(model_instance, key, value)


@app.template_filter('datetimeformat')
def datetimeformat(value, format='%Y-%m-%dT%H:%M'):
    if isinstance(value, datetime):
        return value.strftime(format)
    return value


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/tables_actions')
def tables_actions():
    return render_template('tables_actions.html')


@app.route('/queries')
def queries():
    return render_template('queries.html')


@app.route('/query_1', methods=['GET', 'POST'])
def query_1():
    faculty_name = 'Комп`ютерних наук'

    if request.method == 'POST':
        faculty_name = request.form.get('faculty_name')

    query = (
        db.session.query(Applicants)
        .join(Applications)
        .join(Department)
        .join(Faculty)
        .filter(Faculty.faculty_name == faculty_name)
        .filter(Applications.is_current_application == True)
    )

    applicants = query.all()

    faculties = db.session.query(Faculty.faculty_name).all()

    return render_template(
        'queries/query_1.html',
        applicants=applicants,
        faculties=faculties,
        selected_faculty=faculty_name
    )


@app.route('/query_2', methods=['GET', 'POST'])
def query_2():
    applicant_id = 'ХА-12343'

    if request.method == 'POST':
        applicant_id = request.form.get('applicant_id')

    query = (
        db.session.query(
            Applications.applicant_id,
            Event.event_name,
            func.coalesce(ExamResults.appeal_mark, ExamResults.exam_mark).label('final_mark')
        )
        .join(ExamResults, Applications.application_id == ExamResults.application_id)
        .join(Event, ExamResults.event_id == Event.event_id)
        .filter(
            Applications.applicant_id == applicant_id,
            Applications.is_current_application == True,
            Event.event_type == 1
        )
    )

    exam_results = query.all()

    applicant_ids = db.session.query(Applications.applicant_id).all()

    return render_template(
        'queries/query_2.html',
        exam_results=exam_results,
        applicant_ids=applicant_ids,
        selected_applicant_id=applicant_id
    )


@app.route('/query_3', methods=['GET', 'POST'])
def query_3():
    default_group_name = db.session.query(Group.group_name).first()[0]  # Fetch the first group name

    group_name = default_group_name
    if request.method == 'POST':
        group_name = request.form.get('group_name')

    query = (
        db.session.query(
            Group.group_name,
            Event.event_type,
            Event.subject_name,
            Event.event_start_datetime,
            Event.event_audience
        )
        .join(Stream, Group.stream_id == Stream.stream_id)
        .join(Event, Event.stream_id == Stream.stream_id)
        .join(EventTypes, EventTypes.type_id == Event.event_type)
        .filter(
            EventTypes.type_name == 'Іспит',
            Group.group_name == group_name
        )
    )

    exam_events = query.all()

    group_names = db.session.query(Group.group_name).all()

    return render_template(
        'queries/query_3.html',
        exam_events=exam_events,
        group_names=group_names,
        selected_group_name=group_name
    )


@app.route('/query_4', methods=['GET'])
def query_4():
    query = (
        db.session.query(
            Faculty.faculty_name,
            Event.subject_name,
            func.avg(func.coalesce(ExamResults.appeal_mark, ExamResults.exam_mark)).label('mean_mark')
        )
        .join(Department, Department.faculty_id == Faculty.faculty_id)
        .join(Applications, Applications.department_id == Department.department_id)
        .join(ExamResults, ExamResults.application_id == Applications.application_id)
        .join(Event, Event.event_id == ExamResults.event_id)
        .join(EventTypes, Event.event_type == EventTypes.type_id)
        .filter(EventTypes.type_name == 'Іспит')
        .group_by(Faculty.faculty_name, Event.subject_name)
    )

    faculty_exam_data = query.all()

    return render_template('queries/query_4.html', faculty_exam_data=faculty_exam_data)


@app.route('/applicants')
def applicants():
    all_applicants = Applicants.query.all()
    return render_template('applicants/list.html', applicants=all_applicants)


@app.route('/add_applicant', methods=['GET', 'POST'])
def add_applicant():
    if request.method == 'GET':
        return render_template('applicants/add.html')
    elif request.method == 'POST':
        try:
            new_applicant = Applicants()
            populate_model_from_form(new_applicant, request.form)
            db.session.add(new_applicant)
            db.session.commit()
            flash('Applicant added successfully!', 'success')
            return redirect(url_for('add_applicant'))
        except Exception as e:
            flash(f'Error adding applicant: {str(e)}', 'error')
            return redirect(url_for('add_applicant'))


@app.route('/delete_applicant', methods=['POST'])
def delete_applicant():
    applicant_id = request.form['applicant_id']
    applicant = Applicants.query.get(applicant_id)
    if applicant:
        db.session.delete(applicant)
        db.session.commit()
    return redirect(url_for('applicants'))


@app.route('/edit_applicant', methods=['GET', 'POST'])
def edit_applicant():
    if request.method == 'GET':
        applicant_id = request.args.get('applicant_id')
        applicant = Applicants.query.get(applicant_id)
        return render_template('applicants/edit.html', applicant=applicant)
    elif request.method == 'POST':
        applicant_id = request.form['applicant_id']
        applicant = Applicants.query.get(applicant_id)
        update_model_from_form(applicant, request.form)
        db.session.commit()
        return redirect(url_for('applicants'))


@app.route('/applications')
def applications():
    all_applications = Applications.query.order_by(Applications.application_id.asc()).all()
    return render_template('applications/list.html', applications=all_applications)


@app.route('/add_application', methods=['GET', 'POST'])
def add_application():
    if request.method == 'GET':
        all_applicants = Applicants.query.all()
        all_departments = Department.query.all()
        all_groups = Group.query.all()
        return render_template(
            'applications/add.html', applicants=all_applicants,
            departments=all_departments, groups=all_groups
        )
    elif request.method == 'POST':
        try:
            new_application = Applications()
            populate_model_from_form(new_application, request.form)
            db.session.add(new_application)
            db.session.commit()
            flash('Application added successfully!', 'success')
            return redirect(url_for('add_application'))
        except Exception as e:
            flash(f'Error adding application: {str(e)}', 'error')
            return redirect(url_for('add_application'))


@app.route('/delete_application', methods=['POST'])
def delete_application():
    application_id = request.form['application_id']
    application = Applications.query.get(application_id)
    if application:
        db.session.delete(application)
        db.session.commit()
    return redirect(url_for('applications'))


@app.route('/edit_application', methods=['GET', 'POST'])
def edit_application():
    if request.method == 'GET':
        application_id = request.args.get('application_id')
        application = Applications.query.get(application_id)
        all_applicants = Applicants.query.all()
        all_departments = Department.query.all()
        all_groups = Group.query.all()
        return render_template(
            'applications/edit.html', application=application,
            applicants=all_applicants, departments=all_departments, groups=all_groups
        )
    elif request.method == 'POST':
        application_id = request.form['application_id']
        application = Applications.query.get(application_id)
        update_model_from_form(application, request.form)
        db.session.commit()
        return redirect(url_for('applications'))


@app.route('/faculties')
def faculties():
    all_faculties = Faculty.query.order_by(Faculty.faculty_id.asc()).all()
    return render_template('faculties/list.html', faculties=all_faculties)


@app.route('/add_faculty', methods=['GET', 'POST'])
def add_faculty():
    if request.method == 'GET':
        return render_template('faculties/add.html')
    elif request.method == 'POST':
        try:
            new_faculty = Faculty()
            populate_model_from_form(new_faculty, request.form)
            db.session.add(new_faculty)
            db.session.commit()
            flash('Faculty added successfully!', 'success')
            return redirect(url_for('add_faculty'))
        except Exception as e:
            flash(f'Error adding applicant: {str(e)}', 'error')
            return redirect(url_for('add_faculty'))


@app.route('/delete_faculty', methods=['POST'])
def delete_faculty():
    faculty_id = request.form['faculty_id']
    faculty = Faculty.query.get(faculty_id)
    if faculty:
        db.session.delete(faculty)
        db.session.commit()
    return redirect(url_for('faculties'))


@app.route('/edit_faculty', methods=['GET', 'POST'])
def edit_faculty():
    if request.method == 'GET':
        faculty_id = request.args.get('faculty_id')
        faculty = Faculty.query.get(faculty_id)
        return render_template('faculties/edit.html', faculty=faculty)
    elif request.method == 'POST':
        faculty_id = request.form['faculty_id']
        faculty = Faculty.query.get(faculty_id)
        update_model_from_form(faculty, request.form)
        db.session.commit()
        return redirect(url_for('faculties'))


@app.route('/departments')
def departments():
    all_departments = Department.query.order_by(Department.department_id.asc()).all()
    return render_template('departments/list.html', departments=all_departments)


@app.route('/add_department', methods=['GET', 'POST'])
def add_department():
    if request.method == 'GET':
        all_faculties = Faculty.query.all()
        return render_template(
            'departments/add.html', faculties=all_faculties,
        )
    elif request.method == 'POST':
        try:
            new_department = Department()
            populate_model_from_form(new_department, request.form)
            db.session.add(new_department)
            db.session.commit()
            flash('Department added successfully!', 'success')
            return redirect(url_for('add_department'))
        except Exception as e:
            flash(f'Error adding application: {str(e)}', 'error')
            return redirect(url_for('add_department'))


@app.route('/delete_department', methods=['POST'])
def delete_department():
    department_id = request.form['department_id']
    department = Department.query.get(department_id)
    if department:
        db.session.delete(department)
        db.session.commit()
    return redirect(url_for('departments'))


@app.route('/edit_department', methods=['GET', 'POST'])
def edit_department():
    if request.method == 'GET':
        department_id = request.args.get('department_id')
        department = Department.query.get(department_id)
        all_faculties = Faculty.query.all()
        return render_template(
            'departments/edit.html',
            department=department, faculties=all_faculties,
        )
    elif request.method == 'POST':
        department_id = request.form['department_id']
        department = Department.query.get(department_id)
        update_model_from_form(department, request.form)
        db.session.commit()
        return redirect(url_for('departments'))


@app.route('/eventtypes')
def eventtypes():
    all_eventtypes = EventTypes.query.order_by(EventTypes.type_id.asc()).all()
    return render_template('eventtypes/list.html', eventtypes=all_eventtypes)


@app.route('/add_eventtype', methods=['GET', 'POST'])
def add_eventtype():
    if request.method == 'GET':
        return render_template('eventtypes/add.html')
    elif request.method == 'POST':
        try:
            new_eventtype = EventTypes()
            populate_model_from_form(new_eventtype, request.form)
            db.session.add(new_eventtype)
            db.session.commit()
            flash('EventType added successfully!', 'success')
            return redirect(url_for('add_eventtype'))
        except Exception as e:
            flash(f'Error adding event type: {str(e)}', 'error')
            return redirect(url_for('add_eventtype'))


@app.route('/delete_eventtype', methods=['POST'])
def delete_eventtype():
    type_id = request.form['type_id']
    eventtype = EventTypes.query.get(type_id)
    if eventtype:
        db.session.delete(eventtype)
        db.session.commit()
    return redirect(url_for('eventtypes'))


@app.route('/edit_eventtype', methods=['GET', 'POST'])
def edit_eventtype():
    if request.method == 'GET':
        type_id = request.args.get('type_id')
        eventtype = EventTypes.query.get(type_id)
        return render_template('eventtypes/edit.html', eventtype=eventtype)
    elif request.method == 'POST':
        type_id = request.form['type_id']
        eventtype = EventTypes.query.get(type_id)
        update_model_from_form(eventtype, request.form)
        db.session.commit()
        return redirect(url_for('eventtypes'))


@app.route('/streams')
def streams():
    all_streams = Stream.query.order_by(Stream.stream_id.asc()).all()
    return render_template('streams/list.html', streams=all_streams)


@app.route('/add_stream', methods=['GET', 'POST'])
def add_stream():
    if request.method == 'GET':
        return render_template('streams/add.html')
    elif request.method == 'POST':
        try:
            new_stream = Stream()
            populate_model_from_form(new_stream, request.form)
            db.session.add(new_stream)
            db.session.commit()
            flash('New stream added successfully!', 'success')
            return redirect(url_for('add_stream'))
        except Exception as e:
            flash(f'Error adding event type: {str(e)}', 'error')
            return redirect(url_for('add_stream'))


@app.route('/delete_stream', methods=['POST'])
def delete_stream():
    stream_id = request.form['stream_id']
    stream = EventTypes.query.get(stream_id)
    if stream:
        db.session.delete(stream)
        db.session.commit()
    return redirect(url_for('streams'))


@app.route('/edit_stream', methods=['GET', 'POST'])
def edit_stream():
    if request.method == 'GET':
        stream_id = request.args.get('stream_id')
        stream = Stream.query.get(stream_id)
        return render_template('streams/edit.html', stream=stream)
    elif request.method == 'POST':
        stream_id = request.form['stream_id']
        stream = Stream.query.get(stream_id)
        update_model_from_form(stream, request.form)
        db.session.commit()
        return redirect(url_for('streams'))


@app.route('/events')
def events():
    stream = aliased(Stream)
    event_type = aliased(EventTypes)

    all_events = (
        db.session.query(
            Event.event_id,
            Event.event_name,
            Event.subject_name,
            Event.event_start_datetime,
            Event.event_audience,
            Event.event_duration,
            stream.stream_name,
            event_type.type_name
        )
        .join(stream, Event.stream_id == stream.stream_id)
        .join(event_type, Event.event_type == event_type.type_id)
        .order_by(Event.event_id.asc())
        .all()
    )

    return render_template('events/list.html', events=all_events)


@app.route('/add_event', methods=['GET', 'POST'])
def add_event():
    if request.method == 'GET':
        all_streams = Stream.query.all()
        all_eventtypes = EventTypes.query.all()
        return render_template(
            'events/add.html', streams=all_streams, event_types=all_eventtypes
        )
    elif request.method == 'POST':
        try:
            new_event = Event()
            populate_model_from_form(new_event, request.form)
            db.session.add(new_event)
            db.session.commit()
            flash('New event added successfully!', 'success')
            return redirect(url_for('add_event'))
        except Exception as e:
            flash(f'Error adding application: {str(e)}', 'error')
            return redirect(url_for('add_event'))


@app.route('/delete_event', methods=['POST'])
def delete_event():
    event_id = request.form['event_id']
    event = Event.query.get(event_id)
    if event:
        db.session.delete(event)
        db.session.commit()
    return redirect(url_for('events'))


@app.route('/edit_event', methods=['GET', 'POST'])
def edit_event():
    if request.method == 'GET':
        event_id = request.args.get('event_id')
        event = Event.query.get(event_id)
        all_streams = Stream.query.all()
        all_eventtypes = EventTypes.query.all()
        return render_template(
            'events/edit.html',
            event=event, streams=all_streams, event_types=all_eventtypes
        )
    elif request.method == 'POST':
        event_id = request.form['event_id']
        event = Event.query.get(event_id)
        update_model_from_form(event, request.form)
        db.session.commit()
        return redirect(url_for('events'))


@app.route('/examresults')
def examresults():
    all_examresults = (
        db.session.query(
            ExamResults.application_id,
            Applications.applicant_id,
            ExamResults.event_id,
            Event.event_name,
            ExamResults.exam_mark,
            ExamResults.appeal_status,
            ExamResults.appeal_mark
        )
        .join(Applications, ExamResults.application_id == Applications.application_id)
        .join(Event, ExamResults.event_id == Event.event_id)
        .order_by(ExamResults.application_id, ExamResults.event_id)
        .all()
    )

    return render_template('examresults/list.html', examresults=all_examresults)


@app.route('/add_examresult', methods=['GET', 'POST'])
def add_examresult():
    if request.method == 'GET':
        all_applications = Applications.query.all()
        all_events = Event.query.all()
        return render_template(
            'examresults/add.html',
            applications=all_applications, events=all_events
        )
    elif request.method == 'POST':
        try:
            new_results = ExamResults()
            populate_model_from_form(new_results, request.form)
            db.session.add(new_results)
            db.session.commit()
            flash('New results added successfully!', 'success')
            return redirect(url_for('add_examresult'))
        except Exception as e:
            flash(f'Error adding exam result: {str(e)}', 'error')
            return redirect(url_for('add_examresult'))


@app.route('/delete_examresult', methods=['POST'])
def delete_examresult():
    application_id = request.form['application_id']
    event_id = request.form['event_id']
    result = ExamResults.query.get((application_id, event_id))
    if result:
        db.session.delete(result)
        db.session.commit()
    return redirect(url_for('examresults'))


@app.route('/edit_examresult', methods=['GET', 'POST'])
def edit_examresult():
    if request.method == 'GET':
        application_id = request.args['application_id']
        event_id = request.args['event_id']
        result = ExamResults.query.get((application_id, event_id))
        return render_template(
            'examresults/edit.html',
            examresult=result
        )
    elif request.method == 'POST':
        application_id = request.form['application_id']
        event_id = request.form['event_id']
        result = ExamResults.query.get((application_id, event_id))
        update_model_from_form(result, request.form)
        db.session.commit()
        return redirect(url_for('examresults'))



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
