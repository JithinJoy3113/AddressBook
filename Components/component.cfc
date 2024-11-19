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
        <cfdump  var="#local.uploadPath#">
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

    <cffunction  name="logout" returnType="boolean" access="remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

</cfcomponent>