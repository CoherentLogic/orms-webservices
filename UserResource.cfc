<!---

$Id$

Copyright (C) 2011 John Willis
 
This file is part of Prefiniti.

Prefiniti is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Prefiniti is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Prefiniti.  If not, see <http://www.gnu.org/licenses/>.

--->
<cfcomponent displayname="UserResource" output="false" hint="Webservice for accessing user information">
	
    <!---
    Private szUsername As String
    Private szPasswordHash As String
    Private szEMail As String
    Private pnRealName As PersonName
    Private szSMSNumber As String
    Private szPictureURL As String
    Private bAccountEnabled As Boolean
    Private szGender As String
    Private dtBirthday As Date
    Private bSearchAllowed As Boolean
    Private szORMSID As String
    Private lDatabaseID As Long
	--->

	<cffunction name="Load" returntype="array" output="no" access="remote">
    	<cfargument name="UserName" type="string">
        
        <cfparam name="u" default="">
        <cfset u = ArrayNew(1)>
        
        <cfquery name="l" datasource="webwarecl">
        	SELECT 	id,
            		username,
            		password,
                    email,
                    smsNumber,
                    picture,
                    account_enabled,
                    gender,
                    firstName,
                    lastName,
                    middleInitial,
                    allowSearch,
                    birthday,
                    relationship_status,
                    so_id,
                    zip_code                    
            FROM 	users 
            WHERE 	username='#UserName#'
        </cfquery>
        
		<cfif l.RecordCount GT 0>        
        	<cfset ArrayAppend(u, "id                  " & l.id)>
			<cfset ArrayAppend(u, "username            " & l.username)>
            <cfset ArrayAppend(u, "password            " & l.password)>
            <cfset ArrayAppend(u, "email               " & l.email)>
            <cfset ArrayAppend(u, "smsnumber           " & l.smsNumber)>
            <cfset ArrayAppend(u, "picture             " & l.picture)>
            <cfset ArrayAppend(u, "accountenabled      " & l.account_enabled)>
            <cfset ArrayAppend(u, "gender              " & l.gender)>
            <cfset ArrayAppend(u, "firstname           " & l.firstName)>
            <cfset ArrayAppend(u, "lastname            " & l.lastName)>
            <cfset ArrayAppend(u, "middleinitial       " & l.middleInitial)>
            <cfset ArrayAppend(u, "allowsearch         " & l.allowSearch)>
            <cfset ArrayAppend(u, "birthday            " & DateFormat(l.birthday, "m/dd/yyyy"))>
            <cfset ArrayAppend(u, "relationshipstatus  " & l.relationship_status)>
            <cfset ArrayAppend(u, "soid                " & l.so_id)>
            <cfset ArrayAppend(u, "zipcode             " & l.zip_code)>
		</cfif>
        
        <cfreturn #u#>                        
    </cffunction>
    
    <cffunction name="UserIDFromUsername" returntype="numeric" output="no" access="remote">
    	<cfargument name="Username" type="string">
        
        <cfquery name="uidfu" datasource="webwarecl">
        	SELECT id FROM users WHERE username='#Username#'
        </cfquery>
        
        <cfreturn #uidfu.id#>
    </cffunction>

    <cffunction name="UsernameFromUserID" returntype="string" output="no" access="remote">
    	<cfargument name="UserID" type="numeric">
        
        <cfquery name="unfuid" datasource="webwarecl">
        	SELECT username FROM users WHERE id=#UserID#
        </cfquery>
        
        <cfreturn #unfuid.username#>
    </cffunction>
   
   	<cffunction name="IsOnline" returntype="boolean" output="no" access="remote">
    	<cfargument name="Username" type="string">
        
        <cfquery name="io" datasource="webwarecl">
        	SELECT 	*	
            FROM	auth_tokens
            WHERE	username='#username#'
            AND		active=1
    	</cfquery>
        
        <cfif io.RecordCount GT 0>
        	<cfreturn true>
        <cfelse>
        	<cfreturn false>
        </cfif>
	</cffunction> 
    
    <cffunction name="SigninDate" returntype="string" output="no" access="remote">
    	<cfargument name="Username" type="string">
       
       	<cfif IsOnline(username)> 
            <cfquery name="sd" datasource="webwarecl">
                SELECT 	login_date	
                FROM	auth_tokens
                WHERE	username='#username#'
                AND		active=1
            </cfquery>
            
            <cfif io.RecordCount GT 0>
				<cfset dstr = DateFormat(sd.login_date, "m/dd/yyyy") & " at " & TimeFormat(sd.login_date, "h:mm tt")>
                <cfreturn #dstr#>
            <cfelse>
                <cfset dstr = DateFormat(Now(), "m/dd/yyyy") & " at " & TimeFormat(Now(), "h:mm tt")>
                <cfreturn #dstr#>
            </cfif>
		<cfelse>
        	<cfreturn #Now()#>
        </cfif>            
	</cffunction>
    
    <cffunction name="LastSeen" returntype="string" output="no" access="remote">
    	<cfargument name="Username" type="string">
        
       
        
        <cfquery name="ls" datasource="webwarecl" maxrows="1">
        	SELECT		login_date
            FROM		auth_tokens
            WHERE		username='#username#'
            AND			active=0
            ORDER BY	login_date
            DESC
        </cfquery>
        
        <cfif ls.RecordCount GT 0>
			<cfset dstr = DateFormat(ls.login_date, "m/dd/yyyy") & " at " & TimeFormat(ls.login_date, "h:mm tt")>
            <cfreturn #dstr#>
        <cfelse>
        	<cfreturn "Never"> 
		</cfif>
        
                       
    </cffunction>
       
</cfcomponent>