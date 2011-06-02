<cfcomponent displayname="WebResource" hint="A worldwide web resource" output="false">
	
	<cffunction name="Collect" displayname="Collect" returntype="void" output="false" access="remote">
		<cfargument name="key" type="string">
		<cfargument name="url" type="string">
		
		<cfset turl = BaseURL(url)>
		
		<cfif NOT IsCollected(turl)>
			<cfquery name="collect" datasource="webwarecl">
				INSERT INTO web_resources
							(url,
							registrar)
				VALUES
							('#turl#',
							'NA')
			</cfquery>
            <cfset Hit(key, turl)>
		<cfelse>
			<cfset Hit(key, turl)>
		</cfif>
			
	</cffunction>
	
	<cffunction name="IsCollected" returntype="boolean" output="false" access="public">
		<cfargument name="url" type="string">
		
		<cfquery name="ic" datasource="webwarecl">
			SELECT id FROM web_resources WHERE url='#url#'
		</cfquery>
		
		<cfif ic.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="Rate" displayname="Rate" returntype="void" output="false" access="remote">
		<cfargument name="key" type="string">
		<cfargument name="url" type="string">		
		<cfargument name="category" type="string">
		<cfargument name="rating" type="numeric">
		
		<cfset turl = BaseURL(url)>
		<cfset wr_id = ResourceIDFromURL(turl)>
		<cfset auth_obj = CreateObject("component", "Authentication")>	
		<cfset user_id = auth_obj.UserIDFromKey(key)>
        
        <cfif NOT RatingExists(key, url, category)>       
        	<cfquery name="rate" datasource="webwarecl">
            	INSERT INTO web_resource_ratings
                			(wr_id,
                             user_id,
                             rating,
                             category)
				VALUES		(#wr_id#,
                			 #user_id#,
                             #rating#,
                             '#category#')                                 
            </cfquery>  
        <cfelse>
        	<cfquery name="update_rating" datasource="webwarecl">
            	UPDATE		web_resource_ratings
                SET			rating=#rating#
                WHERE		user_id=#user_id#
          		AND			wr_id=#wr_id#
                AND			category='#category#'
            </cfquery>      
        </cfif>
                       		
	</cffunction>
	
    <cffunction name="RatingExists" returntype="boolean" output="false" access="remote">
    	<cfargument name="key" type="string">
		<cfargument name="url" type="string">		
		<cfargument name="category" type="string">
		
		<cfset turl = BaseURL(url)>
		<cfset wr_id = ResourceIDFromURL(turl)>
		<cfset auth_obj = CreateObject("component", "Authentication")>	
		<cfset user_id = auth_obj.UserIDFromKey(key)>
        
        <cfquery name="re" datasource="webwarecl">
        	SELECT 	id 
            FROM 	web_resource_ratings
            WHERE	wr_id=#wr_id#
            AND		user_id=#user_id#
            AND		category='#category#'
        </cfquery>
        
        <cfif re.RecordCount GT 0>
        	<cfreturn true>
        <cfelse>
        	<cfreturn false>
        </cfif>
    
    </cffunction>
    
	<cffunction name="Share" displayname="Share" returntype="void" output="false" access="remote">
		<cfargument name="key" type="string">

		<cfset turl = BaseURL(url)>
	</cffunction>
			
	<cffunction name="Hit" displayname="Hit" returntype="void" output="false" access="public">
		<cfargument name="key" type="string">
		<cfargument name="url" type="string">
		
		<cfset wr_id = ResourceIDFromURL(url)>

		<cfset auth_obj = CreateObject("component", "Authentication")>	
		<cfset user_id = auth_obj.UserIDFromKey(key)>
		
		
		<cfquery name="hitit" datasource="webwarecl">
			INSERT 	INTO webresource_hits
						(wr_id,
						user_id,
						hit_date)
					VALUES
                    	(#wr_id#,
                        #user_id#,
                        #CreateODBCDateTime(Now())#)
		</cfquery>
		
	</cffunction>
    
    <cffunction name="GetAverageRating" returntype="string" output="no" access="remote">
    	<cfargument name="key" type="string">
        <cfargument name="url" type="string">
        <cfargument name="category" type="string">
        
        <cfset turl = BaseURL(url)>
        <cfset wr_id = ResourceIDFromURL(turl)>
        
        <cfquery name="gr" datasource="webwarecl">
        	SELECT 	AVG(rating) AS AverageRating
			FROM	web_resource_ratings
            WHERE	wr_id=#wr_id#
            AND		category='#category#'
		</cfquery>
        
        
        <cfif gr.RecordCount GT 0>        
	        <cfset retval = gr.AverageRating>                   			
        <cfelse>
        	<cfset retval = 0>
        </cfif>
        
        <cfreturn "#retval#">
    </cffunction>
	
    <cffunction name="GetMyRating" returntype="string" output="no" access="remote">
    	<cfargument name="key" type="string">
    	<cfargument name="url" type="string">
        <cfargument name="category" type="string">
        
        <cfset turl = BaseURL(url)>
        <cfset wr_id = ResourceIDFromURL(turl)>

		<cfset auth_obj = CreateObject("component", "Authentication")>	
		<cfset user_id = auth_obj.UserIDFromKey(key)>
        
        <cfquery name="gmr" datasource="webwarecl">
        	SELECT 	rating
         	FROM	web_resource_ratings
            WHERE	wr_id=#wr_id#
            AND		category='#category#'
            AND		user_id=#user_id#            
		</cfquery>
        
        <cfif gmr.RecordCount GT 0>
	        <cfset retval = gmr.rating>                   			
        <cfelse>
        	<cfset retval = 0>
        </cfif>
        
        <cfreturn "#retval#">
    </cffunction>
    
	<cffunction name="ResourceIDFromURL" returntype="numeric" output="false" access="public">
		<cfargument name="url" type="string">
		
		<cfquery name="ridfu" datasource="webwarecl">
			SELECT id FROM web_resources WHERE url='#url#'
		</cfquery>
	
    	<cfif ridfu.RecordCount GT 0>
			<cfreturn #ridfu.id#>
        <cfelse>
        	<cfreturn 0>
        </cfif>
	</cffunction>
	
	
	<cffunction name="BaseURL" displayname="BaseURL" returntype="string" output="false" access="public">
		<cfargument name="url" type="string">
		
		<cfif left(url, 7) NEQ "http://">
			<cfset turl = "http://" & url>
		<cfelse>
			<cfset turl = url>
		</cfif>
		
		<cfreturn trim(ListGetAt(turl, 2, "/"))>
	</cffunction>
    
    <cffunction name="IsEnhanced" displayname="IsEnhanced" returntype="boolean" output="false" access="remote">
    	<cfargument name="url" type="string">
        
        <cfset turl = BaseURL(url)>
        <cfset wr_id = ResourceIDFromURL(turl)>
        
        <cfquery name="isenhanced" datasource="webwarecl">
        	SELECT pd_enhanced FROM web_resources WHERE id=#wr_id#
        </cfquery>
        
        <cfif isenhanced.pd_enhanced EQ 0>
        	<cfreturn false>
        <cfelse>
        	<cfreturn true>
		</cfif>            
        
    </cffunction>
	
</cfcomponent>