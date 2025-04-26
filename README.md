# readme work in progress

# requirements
- netbeans (any version that isnt too old)
- jdk 11 (get from oracle or openlogic, either works)
- glassfish 6.2.5

# how 2 run dis repo plz help
1. click on code
2. copy the url as shown in the image below

![image](https://i.imgur.com/ch1XeHn.png)

3. go on netbeans (or any ide u use idk we built this on netbeans) and navigate on team > git > clone
4. paste the link into the repository url and select the master branch
5. choose your own directory and clone name (doesnt really matter tho u can just leave it as is lmao)

# why no database/sql wtf!!!!
![image](https://i.imgur.com/VztpoiK.png)

6. create a database with the following (subject to change):        
- String url = "jdbc:derby://localhost:1527/ass";
- String user = "nbuser";
- String password = "nbuser";

![image](https://i.imgur.com/QfaJ3sf.png) 

7. once created, head over to files (press ctrl+2 if its not appearing), expand on the file and you will see a sql file.
8. click on sql file and make sure to set the connection to the same url shown above 
![image](https://i.imgur.com/KNxvIHI.png) 

9. run the sql. if it shows 4 errors its just because of drop table so you can ignore that
10. clean and build the project and run the project.
11. stonks
