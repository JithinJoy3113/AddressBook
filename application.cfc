<cfcomponent>
    <cfset this.name = 'app'>
    <cfset this.sessionManagement = true>
    <cfset this.datasource = "database-jithin">
<!---     <cfset application.obj= new Components.addressbook()>  --->

    <cffunction  name="onRequest" returnType="void">

        <cfargument  name="requestPage" required="true"> 

        <cfset local.excludePages = ["/signUp.cfm","/index.cfm","/sso.cfm"]>

        <cfif ArrayContains(local.excludePages,arguments.requestPage)>
            <cfinclude template="#arguments.requestPage#">
        <cfelseif structKeyExists(session, "userDetails") OR structKeyExists(session, "ssoDetails")>
            <cfinclude  template="#arguments.requestPage#">
        <cfelse>
            <cfset structClear(session)>
            <cfinclude  template="index.cfm">
        </cfif>
    </cffunction>
   
</cfcomponent>