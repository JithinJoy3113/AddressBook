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
                    fullName
                    ,emailID
                    ,userName
                    ,password
                    ,IMAGE
                    )
                VALUES (
                    < cfqueryparam value = '#arguments.fullName#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#local.encrypPass#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#local.fileName#' cfsqltype = "cf_sql_varchar" >
                    )
            </cfquery>
        <cfelse>
            <cfset local.result = false>
        </cfif>

        <cfreturn local.result>
    </cffunction>

    <cffunction  name="userLogin" returnType="boolean">

        <cfargument  name="userName" required="true">
        <cfargument  name="password" required="true">

        <cfset local.result = true>
        <cfset local.encrypPass = Hash(#arguments.password#, 'SHA-512')/> 

        <cfquery name="selectQuery">
            SELECT ID
                ,emailID
                ,password
                ,fullname
                ,IMAGE
            FROM userLogin
            WHERE emailID = < cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar" >
        </cfquery>

        <cfif selectQuery.password EQ local.encrypPass>
            <cfset session.userDetails = selectQuery>
        <cfelse>
            <cfset local.result = false>
        </cfif>
        <cfschedule
                action="update"
                task="#session.userDetails.emailID#-BirthdayMail"
                operation="HTTPRequest"
                startDate="#dateFormat(now())#"
                startTime="9:51 AM"
                endTime = "" 
                url="http://addressbook.com/Components/component.cfc?method=birthdayWishes"
                interval="daily" />
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="contactListView" returnType="query">

        <cfquery name=contactSelect>
            SELECT ID
                ,FirstName
                ,LastName
                ,Email
                ,Mobile
                ,PROFILE
            FROM contactsTable
            WHERE createdBy = < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" >
        </cfquery>

        <cfset local.contactList = contactSelect>
        <cfreturn local.contactList>

    </cffunction>

    <cffunction  name="logout" returnType="boolean" access="remote">

        <cfset structClear(session)>
        <cflocation  url="index.cfm">
        <cfreturn true>
        
    </cffunction>

    <cffunction  name="createContact" returnType="boolean">
    
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
        <cfset local.result = true>
        <cfset local.fileName = "defaultProfile.jpg">
    
        <cfquery name="selectQuery">
            SELECT Email
                ,Mobile
                ,createdBy
            FROM contactsTable
            WHERE Email = < cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >
                OR Mobile = < cfqueryparam value = '#arguments.mobile#' cfsqltype = "cf_sql_varchar" >
                AND createdBy = < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" >
        </cfquery>

        <cfif selectQuery.len() OR arguments.Email EQ session.userDetails.emailID>
            <cfset local.result = false>
        <cfelse>
            <cfif trim(len(arguments.profile))>
                <cfset local.uploadPath = expandPath('./assets/uploadImages')>
                <cffile  action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique"> 
                <cfset local.fileName = cffile.clientFile>
            </cfif>

            <cfquery name="insertQuery">
             INSERT INTO contactsTable (
                    Title
                    ,FirstName
                    ,LastName
                    ,Gender
                    ,DOB
                    ,Address
                    ,Street
                    ,District
                    ,STATE
                    ,Country
                    ,Pincode
                    ,Email
                    ,Mobile
                    ,PROFILE
                    ,createdBy
                    ,createdOn
                    ,updatedBy
                    ,updatedOn
                    )
                VALUES (
                    < cfqueryparam value = '#arguments.title#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.firstName#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.lastName#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.gender#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.date#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.address#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.street#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.district#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.state#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.country#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.pincode#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#arguments.mobile#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#local.fileName#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#dateFormat(now())#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#dateFormat(now())#' cfsqltype = "cf_sql_varchar" >
                    )
            </cfquery>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="updateContact" returnType="boolean" access="remote">
       
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
        <cfset local.result = true>

        <cfquery name="selectQuery"> 
            SELECT Email,Mobile,ID
            FROM contactsTable
            WHERE (Email = < cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" > OR
                Mobile = < cfqueryparam value = '#arguments.mobile#' cfsqltype = "cf_sql_varchar" >) AND
                createdBy = < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" > AND
                NOT ID = < cfqueryparam value = '#session.editID#' cfsqltype = "cf_sql_varchar" >
        </cfquery>

        <cfset local.uploadPath = expandPath('./assets/uploadImages')>

        <cfif QueryRecordCount(selectQuery) OR arguments.Email EQ session.userDetails.emailID>
            <cfset local.result = false>
        <cfelse>
            <cfquery name="profileQuery"> 
                select Profile from contactsTable 
                where 
                ID = <cfqueryparam value='#session.editId#' cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif trim(len(arguments.profile))>
                <cffile  action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique"> 
                <cfset local.filename = cffile.clientFile>
            <cfelse>
                <cfset local.fileName = profileQuery.Profile>
            </cfif>

            <cfquery name="updateQuery">
                UPDATE contactsTable
                SET Title = < cfqueryparam value = '#arguments.title#' cfsqltype = "cf_sql_varchar" >
                    ,FirstName = < cfqueryparam value = '#arguments.firstName#' cfsqltype = "cf_sql_varchar" >
                    ,LastName = < cfqueryparam value = '#arguments.lastName#' cfsqltype = "cf_sql_varchar" >
                    ,Gender = < cfqueryparam value = '#arguments.gender#' cfsqltype = "cf_sql_varchar" >
                    ,DOB = < cfqueryparam value = '#arguments.date#' cfsqltype = "cf_sql_varchar" >
                    ,Address = < cfqueryparam value = '#arguments.address#' cfsqltype = "cf_sql_varchar" >
                    ,Street = < cfqueryparam value = '#arguments.street#' cfsqltype = "cf_sql_varchar" >
                    ,District = < cfqueryparam value = '#arguments.district#' cfsqltype = "cf_sql_varchar" >
                    ,STATE = < cfqueryparam value = '#arguments.state#' cfsqltype = "cf_sql_varchar" >
                    ,Country = < cfqueryparam value = '#arguments.country#' cfsqltype = "cf_sql_varchar" >
                    ,Pincode = < cfqueryparam value = '#arguments.pincode#' cfsqltype = "cf_sql_varchar" >
                    ,Mobile = < cfqueryparam value = '#arguments.mobile#' cfsqltype = "cf_sql_varchar" >
                    ,Email = < cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >
                    ,PROFILE = < cfqueryparam value = '#local.filename#' cfsqltype = "cf_sql_varchar" >
                    ,updatedBy = < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_varchar" >
                    ,updatedOn = < cfqueryparam value = '#dateFormat(now())#' cfsqltype = "cf_sql_varchar" >
                WHERE ID = < cfqueryparam value = '#session.editId#' cfsqltype = "cf_sql_varchar" >
            </cfquery>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="viewContact" returnType="struct" returnFormat="JSON" access="remote">

        <cfargument  name="id" required="true">

        <cfquery name="contactView">
            SELECT ID
                ,Title
                ,FirstName
                ,LastName
                ,Gender
                ,DOB
                ,Address
                ,Street
                ,District
                ,STATE
                ,Country
                ,Pincode
                ,Email
                ,Mobile
                ,PROFILE
            FROM contactsTable
            WHERE Id = < cfqueryparam value = '#arguments.id#' cfsqltype = "cf_sql_varchar" >
        </cfquery>

        <cfset session.editId = contactView.ID>
        <cfset local.jsonData = QueryGetRow(contactView,1)>
        <cfreturn local.jsonData>

    </cffunction>

    <cffunction  name="deleteRow" access="remote">
    
        <cfargument  name="id" required="true">

        <cfquery name="deleteTableRow">
            DELETE
            FROM contactsTable
            WHERE ID = '#arguments.id#';
        </cfquery>

        <cfreturn true>
    </cffunction>

    <cffunction  name="getExcel" returnType="any" access="remote"> 

        <cfquery name="excelSheet">
            SELECT Title
                ,FirstName
                ,LastName
                ,Gender
                ,DOB
                ,Address
                ,Street
                ,District
                ,STATE
                ,Country
                ,Pincode
                ,Email
                ,Mobile
            FROM contactsTable
            WHERE createdBy = < cfqueryparam value = "#session.userDetails.ID#" >
        </cfquery>

        <cfspreadsheet action="write" filename="../assets/spreadSheets/addressBookcontacts.xlsx" overwrite="true" query="excelSheet" sheetname="courses"> 
    
    </cffunction>

    <cffunction  name="getPdf" returnType="query">

        <cfquery name="excelSheet">
            SELECT FirstName
                ,LastName
                ,Gender
                ,DOB
                ,Address
                ,Street
                ,District
                ,PROFILE
                ,STATE
                ,Country
                ,Pincode
                ,Email
                ,Mobile
                ,PROFILE
            FROM contactsTable
            WHERE createdBy = < cfqueryparam value = "#session.userDetails.ID#" >
        </cfquery>

        <cfreturn excelSheet>
    </cffunction>

    <cffunction  name="ssoLogin" returnType="boolean">
        
        <cfargument  name="loginDetails" required="true">
        
        <cfset local.name = arguments.loginDetails['name']>
        <cfset local.email = arguments.loginDetails['other']['email']>
        <cfset local.userName = arguments.loginDetails['other']['given_name']>
        <cfset local.img = arguments.loginDetails['other']['picture']>
        <cfset local.result = true>

        <cfquery name="selectQuery">
           SELECT ID
                ,emailID
                ,password
                ,fullname
                ,IMAGE
            FROM userLogin
            where
                emailId = <cfqueryparam value = '#local.email#' cfsqltype = "cf_sql_varchar" >
        </cfquery>

        <cfif queryRecordCount(selectQuery) GT 0>
            <cfset session.userDetails = selectQuery>
            <cfschedule
                mode="application"
                action="update"
                task="#session.userDetails.emailID#-BirthdayMail"
                operation="HTTPRequest"
                startDate="#dateFormat(now())#"
                startTime="01:35 PM"
                url="http://localhost/demo.cfm"
                interval="daily" />
            <cfreturn true>
        <cfelse>
            <cfquery name="ssoInsert">
            INSERT INTO userLogin (
                    fullName
                    ,emailID
                    ,userName
                    ,IMAGE
                    )
                VALUES (
                    < cfqueryparam value = '#local.name#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#local.email#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#local.userName#' cfsqltype = "cf_sql_varchar" >
                    ,< cfqueryparam value = '#local.img#' cfsqltype = "cf_sql_varchar" >
                    )
            </cfquery>
            <cfquery name="selectQuery">
                SELECT ID
                        ,emailID
                        ,password
                        ,fullname
                        ,IMAGE
                FROM userLogin
                where
                    emailId=<cfqueryparam value='#local.email#' cfsqltype = "cf_sql_varchar" >
            </cfquery>
            <cfset session.userDetails = selectQuery>
        </cfif>
        
        <cfreturn true>
    </cffunction>

    <cffunction  name="birthdayWishes" access="public">

    <cfargument  name="id" required="true">

        <cfquery name="selectDob">
            select 
                DOB
                , Email
                , createdBy
                , firstName
                , lastName
            from contactsTable
            where 
                createdBy = <cfqueryparam value='#arguments.id#' cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfif queryRecordCount(selectDob)>
            <cfloop query="selectDob">
                <cfif  dateFormat(selectDob.DOB,'mm-dd-yyyy') EQ dateFormat(now(),'mm-dd-yyyy')>
                    <cfmail  from="jithinj3113@gmail.com"  subject="subject"  to="#selectDob.Email#">
                            jithin
                    </cfmail>
                </cfif>
            </cfloop>
        </cfif>
        
    </cffunction>

</cfcomponent>