### 🚀 Running the Project in VS Code (Windows)

To compile and deploy this Java Servlet-based project on your local machine using Visual Studio Code (Windows OS), follow these steps:

✅ Step 1: Compile the Project
Open a terminal in your project root directory and run the following command:

```.\.compile.sh ```

This will compile your project and generate a .war (Web Application Archive) file in the target/ directory.

### 📦 Step 2: Deploy to Tomcat
Locate the generated .war file inside the target/ folder.

Copy this file and paste it into the /webapps/ directory of your local Apache Tomcat server.

### 🌐 Step 3: Start the Tomcat Server
Open your browser and go to the Tomcat Manager page (usually http://localhost:8080/manager/html).

Log in using your Tomcat admin username and password.

You should see your project deployed and running.

### 🧪 Step 4: Test Your Servlet
To access the servlet you've developed, open a browser and enter the servlet's URL (e.g., http://localhost:8080/YourAppName/YourServletPath).

You're all set! 🎉

