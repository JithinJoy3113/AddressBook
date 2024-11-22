<cfcomponent>
    <cfset this.name = 'app'>
    <cfset this.sessionManagement = true>
    <cfset this.datasource = "database-jithin">
    <cffunction  name="OnApplicationStart">
        <cfset application.obj= new Components.addressbook()> 
    </cffunction>
    <cffunction  name="onRequest" returnType="void">

        <cfargument  name="requestPage" required="true"> 

        <cfset local.excludePages = ["/jithin/AddressBook/signUp.cfm","/jithin/AddressBook/index.cfm"]>

        <cfif ArrayContains(local.excludePages,arguments.requestPage)>
            <cfinclude  template="#arguments.requestPage#">         
        <cfelseif structKeyExists(session, "userDetails")>
            <cfinclude  template="#arguments.requestPage#">
        <cfelse>
            <cfset structClear(session)>
            <cfinclude  template="index.cfm">
        </cfif>
    </cffunction>
   
</cfcomponent>