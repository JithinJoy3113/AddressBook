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
            select emailID from userLogin where emailID='#arguments.email#'
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

    <cffunction  name = "loginUserData" returnType = "query">
        <cfargument  name="userName" required = "true">
        <cfquery name="selectQuery">
            SELECT ID,
                emailID,
                password,
                fullname,
                IMAGE
            FROM userLogin
            WHERE emailID = < cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfreturn selectQuery>
    </cffunction>

    <cffunction  name="userLogin" returnType="boolean">
        <cfargument  name="userName" required="true">
        <cfargument  name="password" required="true">

        <cfset local.result = true>
        <cfset local.encrypPass = Hash(#arguments.password#, 'SHA-512')/> 
        <cfset local.userData = loginUserData(arguments.userName)>

        <cfif local.userData.password EQ local.encrypPass>
            <cfset session.userDetails = local.userData>
        <cfelse>
            <cfset local.result = false>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="fetchContacts" returnType="query">
    
        <cfargument  name="ID" default=#session.userDetails.ID#>
        <cfset local.columnName = "createdBy">
        <cfif arguments.ID NEQ session.userDetails.ID>
            <cfset local.columnName = "ID">
        </cfif>
        <cfquery name=contactSelect>
            SELECT 
                ID,
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
                Profile
            FROM contactsTable
            WHERE #local.columnName# = < cfqueryparam value = #arguments.ID# cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfreturn contactSelect>
    </cffunction>

    <cffunction  name="logout" returnType="boolean" access="remote">
        <cfset structClear(session)>
        <cflocation  url="index.cfm">
        <cfreturn true>
    </cffunction>

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

        <cfset local.fileName = "defaultProfile.jpg">
        <cfset local.fetchContacts = fetchContacts()>

        <cfloop query="#local.fetchContacts#">
            <cfif arguments.email EQ local.fetchContacts.Email OR arguments.mobile EQ local.fetchContacts.Mobile OR arguments.email EQ session.userDetails.emailID>
                <cfreturn false>
            </cfif>
        </cfloop>
        <cfif trim(len(arguments.profile))>
            <cfset local.uploadPath = expandPath('./assets/uploadImages')>
            <cffile  action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique"> 
            <cfset local.fileName = cffile.clientFile>
        </cfif>
        <cfquery name="insertQuery">
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
                createdOn
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
                < cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp" >
                )
        </cfquery>
        <cfreturn true>
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

        <cfset local.fetchContacts = fetchContacts()>
        <cfset local.uploadPath = expandPath('./assets/uploadImages')>

        <cfloop query=#local.fetchContacts#>
            <cfif (arguments.Email EQ session.userDetails.emailID) OR
                    ((arguments.Email EQ local.fetchContacts.Email OR arguments.mobile EQ local.fetchContacts.Mobile) AND 
                    local.fetchContacts.ID NEQ arguments.editID
                 )>
                <cfreturn false>
            <cfelseif local.fetchContacts.ID EQ arguments.editID>
                <cfset local.fileName = local.fetchContacts.Profile>
            </cfif>
        </cfloop>
 
        <cfif trim(len(arguments.profile))>
            <cffile  action = "upload" destination = "#local.uploadPath#" nameConflict = "MakeUnique"> 
            <cfset local.filename = cffile.clientFile>
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
                updatedOn = < cfqueryparam value = '#dateFormat(now())#' cfsqltype = "cf_sql_varchar" >
            WHERE ID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfreturn true>
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
            DELETE
            FROM contactsTable
            WHERE ID = '#arguments.id#';
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name = "getExcelOrPdf" returnType = "query" access = "remote"> 
        <cfset local.excelSheet = fetchContacts()>
        <cfspreadsheet 
            action="write" 
            filename="../assets/spreadSheets/addressBookcontacts.xlsx" 
            overwrite="true" 
            query="local.excelSheet" 
            sheetname="courses"> 
        <cfreturn local.excelSheet>
    </cffunction>

    <cffunction  name = "ssoLogin" returnType = "boolean">
        
        <cfargument  name ="loginDetails" required = "true">
        <cfset local.name = arguments.loginDetails['name']>
        <cfset local.email = arguments.loginDetails['other']['email']>
        <cfset local.userName = arguments.loginDetails['other']['given_name']>
        <cfset local.img = arguments.loginDetails['other']['picture']>
        <cfset local.result = true>

        <cfset local.userData = loginUserData(local.email)>

        <cfif queryRecordCount(local.userData)>
            <cfset session.userDetails = local.userData>
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
            <cfset session.userDetails = local.userData>
        </cfif>
        <cfreturn true>
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