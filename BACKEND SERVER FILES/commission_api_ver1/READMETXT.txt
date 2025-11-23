TEAM SHAINE MEMBERS:

- Jana LLera - QA
- Lance Mendoza - Database coder
- Shaine Gonida - Database coder
- Fritzie Jaspeo - api command coder 
- Franchesca Dela Gente - api backend command coder


HOW TO RUN


PREREQUISITES:

1. Must have installed xampp
2. Must have installed node.js 

STEP 1

1. Start the Xampp control panel and start apache and MySQL

2. Click on admin in the MySQL

3. Create a database called db_commission

4. Go to import and choose the db_commission_base_file_withsampledata (pull if not in device). Import this into the db_commission database 

5. Keep this tab on

STEP 2 

1. Create a folder and put in all the files within commission_api_ver1

2. Open the db_commission_starter.js, db_commission_frontendsimulationserver.js, db_commission_backendserver.js files

3. Open the node.js command prompt terminal and type: npm install (make sure you are typing this command within the folder that you made containing the commission_api_ver1 files)

4. type in: node db_commission_backendserver.js and run 

5. Wait for message Server running on http://localhost:3000

6. Open a new terminal (without closing the original terminal) and run: node db_commission_frontendsimulationserver.js

7. Go to http://localhost:3000/api/tables/tbl_gendetails 
 