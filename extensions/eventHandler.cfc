/**
* 
* This file is part of MuraPlugin
*
* Copyright 2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true extends='mura.plugin.pluginGenericEventHandler' output=false {

	property name='$' hint='mura scope';

	include '../plugin/settings.cfm';

	public any function onApplicationLoad(required struct $) {
		// Register all event handlers/listeners of this .cfc with Mura CMS
		application.utility.injectMethod('getRequestProtocol',replacementGetRequestProtocol)
	}

	public any function replacementGetRequestProtocol() {

		//evaluate headers
		var headers = getHTTPRequestData().headers;

		if(structKeyExists(headers, "X-Forwarded-Proto")){
			return headers['X-Forwarded-Proto'];
		} else {
					//use current method
					try {
						return listFirst(getPageContext().getRequest().getRequestURL(),":");
					}
					catch(any e) {
						//use Legacy method
						if (len(cgi.HTTPS) and listFindNoCase("Yes,On,True",cgi.HTTPS)) {
							return "https";
						} else if ( isBoolean(cgi.SERVER_PORT_SECURE) and cgi.SERVER_PORT_SECURE ) {
							return "https";
						} else if ( len(cgi.SERVER_PORT) and cgi.SERVER_PORT eq "443" ) {
							return "https";
						} else {
							return "http";
						}
					}
		}
	}

}