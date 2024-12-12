<cfcomponent>

    <cffunction  name="userSignUp" returnType="boolean">
        <cfargument  name="fullName" required="true">
        <cfargument  name="email" required="true">
        <cfargument  name="userName" required="true">
        <cfargument  name="password" required="true">
        <cfargument  name="image" required="true">

        <cfset local.fileName = "defaultProfile.jpg">
        <cfset local.result = true>
        <cfset local.encrypPass = Hash(#arguments.password#, 'SHA-512')/> 

        <cfquery name="selectQuery">
            SELECT emailID 
            FROM userLogin 
            WHERE emailID=< cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >
        </cfquery>

        <cfif trim(len(arguments.image))>
            <cfset local.uploadPath = expandPath('./assets/uploadImages')>
            <cffile  action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique"> 
            <cfset local.fileName = cffile.clientFile>
        </cfif>

        <cfif len(selectQuery.emailID) LT 1>
            <cfquery name="userSignup">
               INSERT INTO userLogin (
                    fullName,
                    emailID,
                    userName,
                    password,
                    IMAGE
                    )
                VALUES (
                    < cfqueryparam value = '#arguments.fullName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#local.encrypPass#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#local.fileName#' cfsqltype = "cf_sql_varchar" >
                    )
            </cfquery>
        <cfelse>
            <cfset local.result = false>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name = "loginUserData" returnType = "boolean">
        <cfargument  name="userMail" required = "true">
        <cfargument  name="password" default="">
        <cfquery name="selectQuery">
            SELECT ID,
                emailID,
                password,
                fullname,
                IMAGE
            FROM userLogin
            WHERE 
                emailID = < cfqueryparam value = #arguments.userMail# cfsqltype = "cf_sql_varchar" > AND
            <cfif arguments.password.len()>
                password = < cfqueryparam value = #arguments.password# cfsqltype = "cf_sql_varchar" >
            <cfelse>
                password IS NULL
            </cfif>
        </cfquery>
        <cfif queryRecordCount(selectQuery)>
            <cfset session.userDetails = selectQuery>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="userLogin" returnType="boolean">
        <cfargument  name="userMail" required="true">
        <cfargument  name="password" required="true">

        <cfset local.encrypPass = Hash(#arguments.password#, 'SHA-512')/> 
        <cfset local.userData = loginUserData(arguments.userMail, local.encrypPass)>

        <cfif local.userData>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif> 
    </cffunction>

    <cffunction  name = "ssoLogin" returnType = "boolean">
        
        <cfargument  name ="loginDetails" required = "true">
        <cfset local.name = arguments.loginDetails['name']>
        <cfset local.email = arguments.loginDetails['other']['email']>
        <cfset local.userName = arguments.loginDetails['other']['given_name']>
        <cfset local.img = arguments.loginDetails['other']['picture']>

        <cfset local.userData = loginUserData(local.email)>

        <cfif local.userData>
            <cfreturn true>
        <cfelse>
            <cfquery name="ssoInsert">
                INSERT INTO userLogin (
                    fullName,
                    emailID,
                    userName,
                    IMAGE
                    )
                VALUES (
                    < cfqueryparam value = '#local.name#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#local.email#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#local.userName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#local.img#' cfsqltype = "cf_sql_varchar" >
                    )
            </cfquery>
            <cfset local.userData = loginUserData(local.email)>
        </cfif>
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="fetchContacts" returnType="query" returnFormat = "JSON">
  
        <cfargument  name="ID" default=#session.userDetails.ID#>
        <cfset local.columnName = "createdBy">
        <cfif arguments.ID NEQ session.userDetails.ID>
            <cfset local.columnName = "ID">
        </cfif>
        <cfquery name=contactSelect>
              SELECT 
				c.ID,
                c.Title,
                c.FirstName,
                c.LastName,
                c.Gender,
                c.DOB,
                c.Address,
                c.Street,
                c.District,
                c.STATE,
                c.Country,
                c.Pincode,
                c.Email,
                c.Mobile,
                c.Profile,
                STRING_AGG(r.Roles , ', ') AS Roles
            FROM 
                contactsTable c
            LEFT JOIN 
                contactRoles cr ON c.ID = cr.contactID 
            LEFT JOIN 
                roleTable r ON cr.roleID = r.roleID
            WHERE #local.columnName# = < cfqueryparam value = #arguments.ID# cfsqltype = "cf_sql_bigint" > AND 
                activeStatus = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" > 
            GROUP BY 
                c.ID,c.Title,c.FirstName,c.LastName,c.Gender,c.DOB,c.Address,c.Street,
                c.District,c.STATE,c.Country,c.Pincode,c.Email,c.Mobile,c.Profile;
        </cfquery>
        <cfreturn contactSelect>
    </cffunction>

    <!--- <cffunction  name="createContact" returnType="any">
        <cfargument  name="title" required="true">
        <cfargument  name="firstName" required="true">
        <cfargument  name="lastName" required="true">
        <cfargument  name="gender" required="true">
        <cfargument  name="date" required="true">
        <cfargument  name="profile">
        <cfargument  name="address" required="true">
        <cfargument  name="street" required="true">
        <cfargument  name="district" required="true">
        <cfargument  name="state" required="true">
        <cfargument  name="country" required="true">
        <cfargument  name="pincode" required="true">
        <cfargument  name="email" required="true">
        <cfargument  name="mobile" required="true">
        <cfargument  name="roles" required="true">

        <cfset local.fileName = "defaultProfile.jpg">

        <cfquery name="selectContacts">
            SELECT 1
            FROM contactsTable
            WHERE Email = < cfqueryparam value = #arguments.email# cfsqltype = "cf_sql_varchar" > OR
                Mobile = < cfqueryparam value = #arguments.mobile# cfsqltype = "cf_sql_varchar" > AND
                createdBy = < cfqueryparam value = #session.userDetails.ID# cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfif selectContacts.len()>
            <cfreturn false>
        <cfelse>
            <cfif trim(len(arguments.profile))>
                <cfset local.uploadPath = expandPath('./assets/uploadImages')>
                <cffile  action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique"> 
                <cfset local.fileName = cffile.clientFile>
            </cfif>
            <cfquery name="insertQuery" result="insertRow">
                INSERT INTO contactsTable (
                    Title,
                    FirstName,
                    LastName,
                    Gender,
                    DOB,
                    Address,
                    Street,
                    District,
                    STATE,
                    Country,
                    Pincode,
                    Email,
                    Mobile,
                    PROFILE,
                    createdBy,
                    createdOn,
                    activeStatus
                    )
                VALUES (
                    < cfqueryparam value = '#arguments.title#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.firstName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.lastName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.gender#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.date#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.address#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.street#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.district#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.state#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.country#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.pincode#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.mobile#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#local.fileName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp" >,
                    < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
                    )
            </cfquery>
            <cfset local.generatedKey = insertRow.generatedKey>
            <cfloop list="#arguments.roles#" item="role">
                <cfquery name="insertRole">
                    INSERT INTO contactRoles(
                        contactID,
                        roleID
                    )
                    VALUES(
                        < cfqueryparam value = '#local.generatedKey#' cfsqltype = "cf_sql_varchar" >,
                        < cfqueryparam value = '#role#' cfsqltype = "CF_SQL_INTEGER" >
                    )
                </cfquery>
            </cfloop>
            <cfreturn true>
        </cfif>
    </cffunction> --->

    <cffunction  name="createContact" returnType="any">
        <cfargument  name="title" required="true">
        <cfargument  name="firstName" required="true">
        <cfargument  name="lastName" required="true">
        <cfargument  name="gender" required="true">
        <cfargument  name="date" required="true">
        <cfargument  name="profile">
        <cfargument  name="address" required="true">
        <cfargument  name="street" required="true">
        <cfargument  name="district" required="true">
        <cfargument  name="state" required="true">
        <cfargument  name="country" required="true">
        <cfargument  name="pincode" required="true">
        <cfargument  name="email" required="true">
        <cfargument  name="mobile" required="true">
        <cfargument  name="roles" required="true">

        <cfset local.fileName = "defaultProfile.jpg">

        <cfquery name="selectContacts">
            SELECT Email,
                Mobile,
                createdBy,
                activeStatus
            FROM contactsTable
            WHERE Email = < cfqueryparam value = #arguments.email# cfsqltype = "cf_sql_varchar" > AND
                Mobile = < cfqueryparam value = #arguments.mobile# cfsqltype = "cf_sql_varchar" > AND
                createdBy = < cfqueryparam value = #session.userDetails.ID# cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfif selectContacts.len() AND selectContacts.activeStatus EQ 1>
            <cfreturn false>
        <cfelse>
            <cfif trim(len(arguments.profile))>
                <cfset local.uploadPath = expandPath('./assets/uploadImages')>
                <cffile  action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique"> 
                <cfset local.fileName = cffile.clientFile>
            </cfif>
            <cfquery name="insertQuery" result="insertRow">
                INSERT INTO contactsTable (
                    Title,
                    FirstName,
                    LastName,
                    Gender,
                    DOB,
                    Address,
                    Street,
                    District,
                    STATE,
                    Country,
                    Pincode,
                    Email,
                    Mobile,
                    PROFILE,
                    createdBy,
                    createdOn,
                    activeStatus
                    )
                VALUES (
                    < cfqueryparam value = '#arguments.title#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.firstName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.lastName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.gender#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.date#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.address#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.street#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.district#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.state#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.country#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.pincode#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.mobile#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#local.fileName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp" >,
                    < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
                    )
            </cfquery>
            <cfset local.generatedKey = insertRow.generatedKey>
            <cfloop list="#arguments.roles#" item="role">
                <cfquery name="insertRole">
                    INSERT INTO contactRoles(
                        contactID,
                        roleID
                    )
                    VALUES(
                        < cfqueryparam value = '#local.generatedKey#' cfsqltype = "cf_sql_varchar" >,
                        < cfqueryparam value = '#role#' cfsqltype = "CF_SQL_INTEGER" >
                    )
                </cfquery>
            </cfloop>
            <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction  name="updateContact" returnType="boolean" access="remote">
       
        <cfargument  name = "editID" required = "true">
        <cfargument  name = "title" required = "true">
        <cfargument  name = "firstName" required = "true">
        <cfargument  name = "lastName" required = "true">
        <cfargument  name = "gender" required = "true">
        <cfargument  name = "date" required = "true">
        <cfargument  name = "profile"> 
        <cfargument  name = "address" required = "true">
        <cfargument  name = "street" required = "true">
        <cfargument  name = "district" required = "true">
        <cfargument  name = "state" required = "true">
        <cfargument  name = "country" required = "true">
        <cfargument  name = "pincode" required = "true">
        <cfargument  name = "email" required = "true">
        <cfargument  name = "mobile" required = "true">
        <cfargument  name="roles" requird="true">

        <cfset local.fetchContacts = fetchContacts(arguments.editID)>
        <cfset local.uploadPath = expandPath('./assets/uploadImages')>

        <cfquery name="selectContacts">
            SELECT *
            FROM contactsTable
            WHERE Email = < cfqueryparam value = #arguments.email# cfsqltype = "cf_sql_varchar" > AND
                Mobile = < cfqueryparam value = #arguments.mobile# cfsqltype = "cf_sql_varchar" > AND
                createdBy = < cfqueryparam value = #session.userDetails.ID# cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfif queryRecordCount(selectContacts) GT 1>
            <cfreturn false>
        <cfelse>
            <cfif trim(len(arguments.profile))>
                <cffile  action = "upload" destination = "#local.uploadPath#" nameConflict = "MakeUnique"> 
                <cfset local.filename = cffile.clientFile>
            <cfelse>
                <cfset local.fileName = selectContacts.Profile>
            </cfif>

            <cfquery name = "updateQuery">
                UPDATE contactsTable
                SET Title = < cfqueryparam value = '#arguments.title#' cfsqltype = "cf_sql_varchar" >,
                    FirstName = < cfqueryparam value = '#arguments.firstName#' cfsqltype = "cf_sql_varchar" >,
                    LastName = < cfqueryparam value = '#arguments.lastName#' cfsqltype = "cf_sql_varchar" >,
                    Gender = < cfqueryparam value = '#arguments.gender#' cfsqltype = "cf_sql_varchar" >,
                    DOB = < cfqueryparam value = '#arguments.date#' cfsqltype = "cf_sql_varchar" >,
                    Address = < cfqueryparam value = '#arguments.address#' cfsqltype = "cf_sql_varchar" >,
                    Street = < cfqueryparam value = '#arguments.street#' cfsqltype = "cf_sql_varchar" >,
                    District = < cfqueryparam value = '#arguments.district#' cfsqltype = "cf_sql_varchar" >,
                    STATE = < cfqueryparam value = '#arguments.state#' cfsqltype = "cf_sql_varchar" >,
                    Country = < cfqueryparam value = '#arguments.country#' cfsqltype = "cf_sql_varchar" >,
                    Pincode = < cfqueryparam value = '#arguments.pincode#' cfsqltype = "cf_sql_varchar" >,
                    Mobile = < cfqueryparam value = '#arguments.mobile#' cfsqltype = "cf_sql_varchar" >,
                    Email = < cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >,
                    PROFILE = < cfqueryparam value = '#local.filename#' cfsqltype = "cf_sql_varchar" >,
                    updatedBy = < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" >,
                    updatedOn = < cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp" >
                WHERE ID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_varchar" >
            </cfquery>

            <cfquery name="deleteRoles">
                DELETE FROM contactRoles
                WHERE contactID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_varchar" >
            </cfquery>

            <cfloop list="#arguments.roles#" item="role">
                <cfquery name="insertRole">
                    INSERT INTO contactRoles(
                        contactID,
                        roleID
                    )
                    VALUES(
                        < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_varchar" >,
                        < cfqueryparam value = '#role#' cfsqltype = "CF_SQL_INTEGER" >
                    )
                </cfquery>
            </cfloop>
            <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction  name = "viewContact" returnType = "struct" returnFormat = "JSON" access = "remote">
        <cfargument  name = "id" required = "true">
        <cfset local.editingRow = fetchContacts(arguments.ID)>
        <cfset local.jsonData = QueryGetRow(local.editingRow,1)>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction  name = "deleteRow" access = "remote">
        <cfargument  name = "id" required = "true">
        <cfquery name = "deleteTableRow">
            UPDATE contactsTable
            SET activeStatus = < cfqueryparam value = 0 cfsqltype = "cf_sql_varchar" >,
                deletedBy = < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_bigint" >,
                deletedOn = < cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp" >
            WHERE ID = '#arguments.id#';
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="logout" returnType="boolean" access="remote">
        <cfset structClear(session)>
        <cflocation  url="index.cfm">
    </cffunction>

    <cffunction  name = "getExcelOrPdf" returnType = "string" access = "remote" returnFormat="json"> 
        <cfargument  name="value" default="">
        <cfset local.excelSheet = fetchContacts()>
        <cfif arguments.value EQ "pdfs">
            <cfset local.nameDate = "jithin_#dateTimeFormat(now(),"dd-mm-yyy-HH.nn.ss")#.pdf">
            <cfoutput>
                <cfdocument format = "pdf"
                    filename = "../assets/pdfs/#local.nameDate#" 
                    overwrite = "true"
                    bookmark = "no" 
                    orientation = "landscape"
                    localUrl = "yes">
                    <table>
                        <tr>
                            <th>FirstName</th>
                            <th>LastName</th>
                            <th>Gender</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Mobile</th>
                            <th>Address</th>
                            <th>Pincode</th>
                            <th>Image</th>
                        </tr>
                        <cfloop query="local.excelSheet">
                            <tr>
                                <td>#FirstName#</td>
                                <td>#LastName#</td>
                                <td>#Gender#</td>
                                <td>#Email#</td>
                                <td>#Roles#</td>
                                <td>#Mobile#</td>
                                <td>#Address#, #Street#, #District#, #State#, #Country#</td>
                                <td>#Pincode#</td>
                                <td><img src="../assets/uploadImages/#Profile#" width="60" height="60"></td>
                            </tr>
                        </cfloop>
                    </table>
                </cfdocument>
            </cfoutput>
        <cfelse>
            <cfset local.nameDate = "jithin_#dateTimeFormat(now(),"dd-mm-yyy-HH.nn.ss")#.xlsx">
            <cfspreadsheet 
                action="write" 
                filename="../assets/spreadSheets/#local.nameDate#" 
                overwrite="true" 
                query="local.excelSheet" 
                sheetname="courses"> 
        </cfif>
        <cfreturn local.nameDate>
    </cffunction>

    <cffunction  name="birthdayWishes" access="public">
        <cfset local.selectDob = fetchContacts()>
        <cfif queryRecordCount(local.selectDob)>
            <cfloop query="local.selectDob">
                <cfif  dateFormat(local.selectDob.DOB,'mm-dd-yyyy') EQ dateFormat(now(),'mm-dd-yyyy')>
                    <cfmail  from="jithinj3113@gmail.com" subject="Birthday Mail" to="#local.selectDob.Email#">
                            Happy Birthday #local.selectDob.firstName# #local.selectDob.lastName#
                    </cfmail>
                </cfif>
            </cfloop>
        </cfif>
    </cffunction>

</cfcomponent>