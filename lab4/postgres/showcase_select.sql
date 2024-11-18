\c lab4
SET search_path to lab4_app;

select memcache_get('/applicant_exam_results_ХА-12344');

delete from examresults where application_id IN
(SELECT application_id from applications where applicant_id = 'ХА-12344');
delete from applications where applicant_id = 'ХА-12344';

select memcache_get('/applicant_exam_results_ХА-12344');
