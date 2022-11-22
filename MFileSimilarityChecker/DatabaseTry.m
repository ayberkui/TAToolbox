clear

studentNames = {'Merve Yavuzkaya', 'Umur Ayberk', 'Björn Ironside'};
studentMails = {'merve_yavuzkaya_boun_edu_tr', 'umur_ayberk_boun_edu_tr', 'bjorn_ironside_mau_se'};
n = length(studentMails);

for i = n:-1:1
    Name = studentNames{i};
    Mail = studentMails{i};
    Student.name = Name;
    Student.mail = Mail;
    Student.DBID = i;
    Students(i) = Student;
end

