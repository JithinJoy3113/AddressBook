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

        <cfquery name="local.selectQuery">
            SELECT 
                emailID 
            FROM 
                userLogin 
            WHERE 
                emailID=< cfqueryparam value = '#arguments.email#' cfsqltype = "cf_sql_varchar" >
        </cfquery>

        <cfif trim(len(arguments.image))>
            <cfset local.uploadPath = expandPath('./assets/uploadImages')>
            <cffile  action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique"> 
            <cfset local.fileName = cffile.clientFile>
        </cfif>

        <cfif len(selectQuery.emailID) LT 1>
            <cfquery name="local.userSignup">
               INSERT INTO 
                    userLogin (
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
        <cfquery name="local.selectQuery">
            SELECT 
                ID,
                emailID,
                password,
                fullname,
                IMAGE
            FROM 
                userLogin
            WHERE 
                emailID = < cfqueryparam value = #arguments.userMail# cfsqltype = "cf_sql_varchar" > AND
            <cfif arguments.password.len()>
                password = < cfqueryparam value = #arguments.password# cfsqltype = "cf_sql_varchar" >
            <cfelse>
                password IS NULL
            </cfif>
        </cfquery>
        <cfif queryRecordCount(local.selectQuery)>
            <cfset session.userDetails = local.selectQuery>
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
        
        <cfargument name ="loginDetails" required = "true">
        <cfset local.name = arguments.loginDetails['name']>
        <cfset local.email = arguments.loginDetails['other']['email']>
        <cfset local.userName = arguments.loginDetails['other']['given_name']>
        <cfset local.img = arguments.loginDetails['other']['picture']>

        <cfset local.userData = loginUserData(local.email)>

        <cfif local.userData>
            <cfreturn true>
        <cfelse>
            <cfquery name="local.ssoInsert">
                INSERT INTO 
                    userLogin (
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

    <cffunction  name="fetchRoles" returnType="any">
        <cfargument  name="roleList" required="true">

        <cfquery name="local.roleSelect">
            SELECT
                roleID,
                Roles
            FROM
                roleTable
        </cfquery>
        <cfset local.newRoles = "" />
        <cfloop list="#arguments.roleList#" item="role">
            <cfset local.matchedRoleID = "">

            <cfloop query="local.roleSelect">
                <cfif role EQ local.roleSelect.Roles>
                    <cfset local.matchedRoleID = local.roleSelect.roleID>
                    <cfbreak>
                </cfif>
            </cfloop>
        <cfset local.newRoles = listAppend(local.newRoles, local.matchedRoleID)> 
        </cfloop>
        <cfreturn local.newRoles>
    </cffunction>
    
    <cffunction  name="fetchContacts" returnType="query" returnFormat = "JSON">
  
        <cfargument  name="ID" default=#session.userDetails.ID#>
        <cfset local.columnName = "createdBy">
        <cfif arguments.ID NEQ session.userDetails.ID>
            <cfset local.columnName = "ID">
        </cfif>
        <cfquery name="local.contactSelect">
              SELECT 
                <cfif arguments.ID EQ "excelSheet">
                    TOP 0
                </cfif> 
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
            <cfif arguments.ID NEQ "excelSheet">
                WHERE 
                    #local.columnName# = < cfqueryparam value = #arguments.ID# cfsqltype = "cf_sql_bigint" > AND 
                    activeStatus = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" > 
            </cfif>
            GROUP BY 
                c.ID,c.Title,c.FirstName,c.LastName,c.Gender,c.DOB,c.Address,c.Street,
                c.District,c.STATE,c.Country,c.Pincode,c.Email,c.Mobile,c.Profile;
        </cfquery>
        <cfreturn local.contactSelect>
    </cffunction>

    <cffunction  name="createContact" returnType="any">
        <cfargument  name="title" required="true">
        <cfargument  name="firstName" required="true">
        <cfargument  name="lastName" required="true">
        <cfargument  name="gender" required="true">
        <cfargument  name="date" required="true">
        <cfargument  name="profile" default="">
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

        <cfquery name="local.selectContacts">
            SELECT 
                Email,
                createdBy,
                activeStatus
            FROM 
                contactsTable
            WHERE 
                Email = < cfqueryparam value = #arguments.email# cfsqltype = "cf_sql_varchar" > AND
                createdBy = < cfqueryparam value = #session.userDetails.ID# cfsqltype = "cf_sql_varchar" >AND
                activeStatus =< cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfif queryRecordCount(local.selectContacts) AND local.selectContacts.activeStatus EQ 1>
            <cfreturn false>
        <cfelse>
            <cfif trim(len(arguments.profile))>
                <cfset local.uploadPath = expandPath('./assets/uploadImages')>
                <cffile  action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique"> 
                <cfset local.fileName = cffile.clientFile>
            </cfif>
            <cfquery name="local.insertQuery" result="insertRow">
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
                    < cfqueryparam value = '#arguments.date#' cfsqltype = "cf_sql_date" >,
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
            <cfset local.roles = fetchRoles(arguments.roles)>
            <cfset local.generatedKey = insertRow.generatedKey>
            <cfloop list="#local.roles#" item="role">
                <cfquery name="insertRole">
                    INSERT INTO 
                        contactRoles(
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
        <cfargument  name = "profile" default=""> 
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

        <cfquery name="local.selectContacts">
            SELECT *
            FROM 
                contactsTable
            WHERE 
                Email = < cfqueryparam value = #arguments.email# cfsqltype = "cf_sql_varchar" > AND
                createdBy = < cfqueryparam value = #session.userDetails.ID# cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfif queryRecordCount(local.selectContacts) GT 1>
            <cfreturn false>
        <cfelse>
            <cfif trim(len(arguments.profile))>
                <cffile  action = "upload" destination = "#local.uploadPath#" nameConflict = "MakeUnique"> 
                <cfset local.filename = cffile.clientFile>
            <cfelse>
                <cfset local.fileName = local.selectContacts.Profile>
            </cfif>

            <cfquery name = "local.updateQuery">
                UPDATE 
                    contactsTable
                SET 
                    Title = < cfqueryparam value = '#arguments.title#' cfsqltype = "cf_sql_varchar" >,
                    FirstName = < cfqueryparam value = '#arguments.firstName#' cfsqltype = "cf_sql_varchar" >,
                    LastName = < cfqueryparam value = '#arguments.lastName#' cfsqltype = "cf_sql_varchar" >,
                    Gender = < cfqueryparam value = '#arguments.gender#' cfsqltype = "cf_sql_varchar" >,
                    DOB = < cfqueryparam value = '#arguments.date#' cfsqltype = "cf_sql_date" >,
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
                WHERE 
                    ID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_varchar" >
            </cfquery>

            <cfquery name="local.deleteRoles">
                DELETE FROM 
                    contactRoles
                WHERE 
                    contactID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_varchar" >
            </cfquery>

            <cfset local.roles = fetchRoles(arguments.roles)>
            <cfloop list="#local.roles#" item="role">
                <cfquery name="local.insertRole">
                    INSERT INTO 
                        contactRoles(
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
        <cfquery name = "local.deleteTableRow">
            UPDATE 
                contactsTable
            SET 
                activeStatus = < cfqueryparam value = 0 cfsqltype = "cf_sql_varchar" >,
                deletedBy = < cfqueryparam value = '#session.userDetails.ID#' cfsqltype = "cf_sql_bigint" >,
                deletedOn = < cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp" >
            WHERE
                ID = '#arguments.id#';
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

    <cffunction  name="plainExcelSheet" returnType="boolean" access = "remote"> 
        <cfset local.plainTemplate = fetchContacts("excelSheet")>
        <cfset local.plainTemplate=QueryDeleteColumn(local.plainTemplate,"Profile")>
        <cfset local.plainTemplate=QueryDeleteColumn(local.plainTemplate,"ID")>
        <cfspreadsheet 
            action="write" 
            filename="../assets/spreadSheets/plainTemplate.xlsx" 
            overwrite="true" 
            query="local.plainTemplate" 
            sheetname="contacts"> 
        <cfreturn true>
    </cffunction>

    <cffunction  name="createExcelContact" returnType="any" access="remote">
        <cfargument  name="uploadProfile">
        <cfspreadsheet  action="read" src="#arguments.uploadProfile#" query="local.excelHeader" headerRow="1" excludeHeaderRow="true">
        <cfset local.count = 0>
        <cfset local.resultQuery = Duplicate(local.excelHeader)>
        <cfset QueryAddColumn(local.resultQuery, "Result", "varchar",[])>
        <cfloop query="local.excelHeader">
            <cfset local.missingDatas = false>
            <cfset local.count += 1>
            <cfset local.result = arrayNew(1)>
             <cfloop list="#local.excelHeader.columnList#" item="column">
                <cfset local.value = local.excelHeader[column]>
                <cfif len(local.value) LT 1 OR column EQ "Result" >
                    <cfset arrayAppend(local.result, "#column# must not be Empty")>

                <cfelseif column EQ "Title" AND (local.value NEQ "Mr" AND local.value NEQ "Miss")>
                    <cfset arrayAppend(local.result, "#column# must be valid data(Mr/Miss)")>

                <cfelseif column EQ "Email" AND NOT(isValid("email", "#local.value#"))> 
                    <cfset arrayAppend(local.result, "#column# must be valid Format")>

                <cfelseif column EQ "Mobile"  AND NOT(REFind("^\d{10}$", "#local.value#"))>
                    <cfset arrayAppend(local.result, "#column# must be valid Format(10 digits)")>

                <cfelseif column EQ "Pincode" AND NOT(REFind("^\d{6}$", "#local.value#"))>
                    <cfset arrayAppend(local.result, "#column# must be valid Format(6 digits)")>

                <cfelseif column EQ "Gender" AND (local.value NEQ "Male" AND local.value NEQ "Female")>
                    <cfset arrayAppend(local.result, "#column# must be valid data(Male/Female)")>

                <cfelseif column EQ "DOB">
                    <cfset local.dateDiff = dateDiff("d", dateFormat(now()), local.value)>
                    <cfif NOT IsDate(local.value)>
                        <cfset arrayAppend(local.result, "#column# must be valid date(dd-mm-yyyy)")>
                    <cfelseif local.dateDiff GT 0>
                        <cfset arrayAppend(local.result, "Cannot add the future dates")>
                    </cfif>
                <cfelse>
                    <cfcontinue>
                </cfif> 
            </cfloop>

            <cfif local.result.len()>
                <cfset local.resultQuery.Result[local.count] = local.result >
            <cfelse>
                <cfset local.title = local.excelHeader.Title>
                <cfset local.firstName = local.excelHeader.FirstName>
                <cfset local.lastName = local.excelHeader.LastName>
                <cfset local.gender = local.excelHeader.Gender>
                <cfset local.date = local.excelHeader.DOB>
                <cfset local.address = local.excelHeader.Address>
                <cfset local.street = local.excelHeader.Street>
                <cfset local.district = local.excelHeader.District>
                <cfset local.state = local.excelHeader.State>
                <cfset local.country = local.excelHeader.Country>
                <cfset local.pincode = local.excelHeader.Pincode>
                <cfset local.email = local.excelHeader.Email>
                <cfset local.mobile = local.excelHeader.Mobile>
                <cfset local.roles = local.excelHeader.Roles>
                <cfset local.functionResult = createContact(
                                                        title = local.title,
                                                        firstName = local.firstName,
                                                        lastName = local.lastName,
                                                        gender = local.gender,
                                                        date = local.date,
                                                        address = local.address,
                                                        street = local.street,
                                                        district = local.district,
                                                        state = local.state,
                                                        country = local.country,
                                                        pincode = local.pincode,
                                                        email = local.email,
                                                        mobile = local.mobile,
                                                        roles = local.roles
                )>
                <cfif local.functionResult>
                    <cfset local.resultQuery.Result[local.count] = "Contact Added">
                <cfelse>
                    <cfquery name="local.idSelect">
                        SELECT 
                            Email,
                            ID
                        FROM
                            contactsTable
                        WHERE
                            Email=< cfqueryparam value = '#local.email#' cfsqltype = "cf_sql_varchar" >AND
                            createdBy = < cfqueryparam value = #session.userDetails.ID# cfsqltype = "cf_sql_bigint" >
                    </cfquery>
                    <cfset local.UpdateFunctionResult = updateContact(
                                                        editId=idSelect.ID,
                                                        title = local.title,
                                                        firstName = local.firstName,
                                                        lastName = local.lastName,
                                                        gender = local.gender,
                                                        date = local.date,
                                                        address = local.address,
                                                        street = local.street,
                                                        district = local.district,
                                                        state = local.state,
                                                        country = local.country,
                                                        pincode = local.pincode,
                                                        email = local.email,
                                                        mobile = local.mobile,
                                                        roles = local.roles
                    )>
                    <cfset local.resultQuery.Result[local.count] = "Contact Updated">
                </cfif>
            </cfif>
        </cfloop >
        <cfset QuerySort(local.resultQuery, sortExcelResult)>
        <cfspreadsheet 
            action="write" 
            filename="../assets/spreadSheets/result.xlsx" 
            overwrite="true" 
            query="local.resultQuery" 
            sheetname="contacts"> 
        <cfreturn>
    </cffunction>

    <cffunction  name="sortExcelResult" returnType = "numeric">
        <cfargument  name="row1">
        <cfargument  name="row2">

        <cfset local.resultOrder = {"Contact Updated": 1, "Contact Added": 2}>
        <cfif isValid("string",arguments.row1.Result) And isValid("string",arguments.row2.Result) >
            <cfreturn compare(local.resultOrder[arguments.row1.Result], local.resultOrder[arguments.row2.Result])>
        <cfelseif isValid("string",arguments.row1.Result)>
            <cfreturn 1>
        <cfelse>
            <cfreturn -1>
        </cfif>
    </cffunction>

</cfcomponent>