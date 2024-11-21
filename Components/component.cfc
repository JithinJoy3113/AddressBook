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
                insert into userLogin (fullName,emailID,userName,password,image)values(
                    <cfqueryparam value='#arguments.fullName#' cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value='#arguments.email#' cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value='#arguments.userName#' cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value='#local.encrypPass#' cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value='#local.fileName#' cfsqltype="cf_sql_varchar">)
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
            select ID,emailID,password,fullname,image from userLogin where emailID=<cfqueryparam value='#arguments.userName#' cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif selectQuery.password EQ local.encrypPass>
            <cfset session.userDetails = selectQuery>
        <cfelse>
            <cfset local.result = false>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="contactListView" returnType="query">
        <cfquery name=contactSelect>
            select ID, FirstName, LastName, Email, Mobile, Profile from contactsTable where createdBy=<cfqueryparam value='#session.userDetails.ID#' cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset local.contactList = contactSelect>
        <cfreturn local.contactList>
    </cffunction>

    <cffunction  name="logout" returnType="boolean" access="remote">
        <cfset structClear(session)>
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
            select Email, Mobile, createdBy from contactsTable where Email=<cfqueryparam value='#arguments.email#' cfsqltype="cf_sql_varchar"> And 
                            Mobile=<cfqueryparam value='#arguments.mobile#' cfsqltype="cf_sql_varchar"> AND
                            createdBy=<cfqueryparam value='#session.userDetails.ID#' cfsqltype="cf_sql_varchar">
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
                insert into contactsTable (Title, FirstName, LastName, Gender, DOB, Address, Street, District, State, Country,Pincode, Email, Mobile, Profile, createdBy, createdOn, updatedBy, updatedOn) 
                values
                (<cfqueryparam value='#arguments.title#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.firstName#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.lastName#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.gender#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.date#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.address#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.street#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.district#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.state#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.country#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.pincode#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.email#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#arguments.mobile#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#local.fileName#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#session.userDetails.ID#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#dateFormat(now())#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#session.userDetails.ID#' cfsqltype="cf_sql_varchar">,
                <cfqueryparam value='#dateFormat(now())#' cfsqltype="cf_sql_varchar">)
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
            select Email from contactsTable where 
                Email=<cfqueryparam value='#arguments.email#' cfsqltype="cf_sql_varchar"> AND
                createdBy=<cfqueryparam value='#session.userDetails.ID#' cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset local.uploadPath = expandPath('./assets/uploadImages')>
        <cfif selectQuery.len() GT 1>
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
                update contactsTable set
                Title = <cfqueryparam value='#arguments.title#' cfsqltype="cf_sql_varchar">,
                FirstName = <cfqueryparam value='#arguments.firstName#' cfsqltype="cf_sql_varchar">,
                LastName = <cfqueryparam value='#arguments.lastName#' cfsqltype="cf_sql_varchar">,
                Gender = <cfqueryparam value='#arguments.gender#' cfsqltype="cf_sql_varchar">,
                DOB = <cfqueryparam value='#arguments.date#' cfsqltype="cf_sql_varchar">,
                Address = <cfqueryparam value='#arguments.address#' cfsqltype="cf_sql_varchar">,
                Street = <cfqueryparam value='#arguments.street#' cfsqltype="cf_sql_varchar">,
                District = <cfqueryparam value='#arguments.district#' cfsqltype="cf_sql_varchar">,
                State = <cfqueryparam value='#arguments.state#' cfsqltype="cf_sql_varchar">,
                Country = <cfqueryparam value='#arguments.country#' cfsqltype="cf_sql_varchar">,
                Pincode = <cfqueryparam value='#arguments.pincode#' cfsqltype="cf_sql_varchar">,
                Mobile = <cfqueryparam value='#arguments.mobile#' cfsqltype="cf_sql_varchar">,
                Email = <cfqueryparam value='#arguments.email#' cfsqltype="cf_sql_varchar">,
                Profile = <cfqueryparam value='#local.filename#' cfsqltype="cf_sql_varchar">,
                updatedBy = <cfqueryparam value='#session.userDetails.ID#' cfsqltype="cf_sql_varchar">,
                updatedOn = <cfqueryparam value='#dateFormat(now())#' cfsqltype="cf_sql_varchar">
                where 
                ID = <cfqueryparam value='#session.editId#' cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfif>
         <cfreturn local.result>
    </cffunction>

    <cffunction  name="viewContact" returnType="struct" returnFormat="JSON" access="remote">
        <cfargument  name="id" required="true">

        <cfquery name="contactView">
            select ID, Title, FirstName, LastName, Gender, DOB, Address, Street, District, State, Country, Pincode, Email, Mobile, Profile 
            from contactsTable 
            where 
            Id=<cfqueryparam value='#arguments.id#' cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset session.editId = contactView.ID>
        <cfset local.jsonData = QueryGetRow(contactView,1)>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction  name="deleteRow" access="remote">
    
        <cfargument  name="id" required="true">
        <cfquery name="deleteTableRow">
            delete from contactsTable where ID='#arguments.id#';
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="getExcel" returnType="any">

        <cfquery name="excelSheet">
            select Title, FirstName, LastName, Gender, DOB, Address, Street, District, State, Country, Pincode, Email, Mobile from contactsTable 
        </cfquery>
        <cfspreadsheet action="write" filename="../assets/sheet.xlsx" query="excelSheet" sheetname="courses" overwrite=true> 
    </cffunction>

    <cffunction  name="getPdf" returnType="query">
        <cfquery name="excelSheet">
            select  FirstName,
                    LastName,
                    Gender,
                    DOB,
                    Address,
                    Street,
                    District,
                    Profile,
                    State,
                    Country,
                    Pincode,
                    Email,
                    Mobile,
                    Profile
            from contactsTable 
            where createdBy=<cfqueryparam value="#session.userDetails.ID#">
        </cfquery>

        <cfreturn excelSheet>
    </cffunction>

</cfcomponent>