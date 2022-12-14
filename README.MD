## TA Toolbox - ayberkui
___
### Features
* **MFCarchive** : Similarity check for M files and archival in an excel sheet.
* **commentClrs** : Go through all M files in a folder and comment out the "clear" commands.
* **RunMFiles/RunMFiles2** : Sequentially run all M Files in a folder with a clean workspace and submit grades with feedback to a class list excel sheet.
___
### MFCarchive
Expands on [mfilecompare](https://www.mathworks.com/matlabcentral/fileexchange/29781-mfilecompare) by Mathias Benedek to record the similarities between participants over different assignments as seperate excel sheets.

Created having [Matlab Grader](https://grader.mathworks.com/) in mind but can be generalized with minor modifications. 

Uses a template excel sheet for the classroom as shown below.

![ExcelTemplate](./Images/MFCarchive_Template.jpg)

**Template.xlsx** needs to be in the directory where you call MFCarchive. The file names in the assignment directory are matched agains the second column in the **Template.xlsx**. You are prompted to pick the directory that contains the M Files to be checked. Then a second prompt will ask you about the assignment number, question name, similarity threshold, and wheter or not you want to save the similarity results in an excel sheet.

If you choose to save the similarity values, **OverlapText.xlsx** is created in your working directory. If **OverlapText.xlsx** already exists, a new sheet with assignment number and question name is created in the same file.
___
### commentClrs

Given a folder path, goes through the M Files in the directory and comments out any lines that start with **clear**. It is useful when you use **RunMFiles** as clear commands prevent the script from running as intended.
___
### RunMFiles - RunMFiles2

Sequentially runs all M Files in a directory, cleaning the  workspace and closing all figure windows in between each. It is also possible to run functions with specified inputs using variables:
* AssessmentIsFun : It is enough to have this variable in the workspace, can be empty.
* AssessmentInputs : Cell array where each cell is an input to be given to the student functions.
* AssessmentOutputs : Cell array where each cell is a string for output variable names.

Before the script begins, you will be prompted to select a class list. If you dont select one, the script will just run the student scripts and finish. If you specify a class list, after each script, the name of the file will be matched with a student name from the class list and you will be prompted to enter a grade value and feedback text. At the end of the run, the grades and feedbacks are saved with the class list to an excel sheet named **TempGrades.xls** in the folder of the M Files.
The class list should be formatted as below.
![ClassTemp](./Images/classlist.jpg)