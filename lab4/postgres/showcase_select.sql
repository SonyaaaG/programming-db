\c lab4
SET search_path to lab4_app;

select memcache_get('/applicant_exam_results_ХА-12344');

delete from examresults where application_id IN
(SELECT application_id from applications where applicant_id = 'ХА-12344');
delete from applications where applicant_id = 'ХА-12344';

select memcache_get('/applicant_exam_results_ХА-12344');

--
UPDATE examresults
SET appeal_status = TRUE, appeal_mark = 95
WHERE application_id = 6 AND event_id = 8;

--
INSERT INTO applications(applicant_id, department_id, group_id, is_current_application)
VALUES ('ХА-12345', 1, 1, True);
