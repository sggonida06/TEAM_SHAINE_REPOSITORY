TEAM SHAINE MEMBERS:

- Jana LLera - Workflow manager, qa
- Lance Mendoza - Database coder
- Shaine Gonida - Database coder
- Fritzie Jaspeo - api command coder 
- Franchesca Dela Gente - api backend command coder


HOW TO RUN


PREREQUISITES:

1. Must have installed xampp
2. Must have installed node.js 
3. Must have installed thunderclient vs extension.

STEP 1

1. Start the Xampp control panel and start apache and MySQL

2. Click on admin in the MySQL

3. Create a database called db_commission

4. Go to import and choose the db_commission_final file (pull if not in device). Import this into the db_commission database 

5. Keep this tab on

STEP 2 

1. Create a folder and put in all the files within commission_api_ver1

2. Open the db_commission_starter.js, db_commission_frontendsimulationserver.js, db_commission_backendserver.js files

3. Open the node.js command prompt terminal and type: npm install (make sure you are typing this command within the folder that you made containing the commission_api_ver1 files)

4. type in: node db_commission_backendserver.js and run 

5. Wait for message Server running on http://localhost:3000

6. Open a new terminal (without closing the original terminal) and run: node db_commission_frontendsimulationserver.js

7. Go to http://localhost:3000/api/tables/tbl_gendetails in the browser



THUNDERCLIENT

1. After installing thunderclient, click on the thunder symbol in the left side of vs code

2. For different functions, refer to the db_commission_backendserver file. 

Example 1: 


Code snippet from db_commission_backendserver:

app.get('/api/tables/tbl_gendetails', async (req, res) => {

What to input in thunderclient

get - http://localhost:3000/api/tables/tbl_gendetails (shows general details table)


Example 2: 


Code snippet from db_commission_backendserver:

app.post('/api/orders/cancel', async (req, res) => {

What to input in thunderclient

post - http://localhost:3000/api/orders/cancel

NOTE: This function needs a data so if you are canceling OrderId : 12345,

Input the following into the JSON Body (take note of the syntax): 

{
  "orderId": 12345
}






 