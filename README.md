# SQLiteDemo
SQLite example with multiple tables.

Design native iOS app (swift) which showcase the following actions in a sequence of screens. There is no BE. Dummify/Hardcode all data in the app itself. 

1. A student A enters his university ID number and pswd
2. A sees a list of free sessions available with the dean. Each dean slot is 1 hr long and dean is only available on Thur, Fri 10 AM every week.
3. A picks one of the above slots and books. A logs out.
4. Dean logins in with his university ID and pswd (similar to 1 above). 
5. Dean sees a list of all pending sessions - student name, and slot details. Currently only A.
6. Student B logs in, gets a list of free slots and books a slot. B logs out.
7. Dean logs in back and sees a list of his pending sessions - both A and B.

Instructions - 
1.Added hardcode certain university IDs to represent A n B n Dean.
2.Since there are no BE APIs, app is work even without any internet on the mobile.
