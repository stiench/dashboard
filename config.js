/* Config Sample
 *
 * For more information on how you can configure this file
 * see https://docs.magicmirror.builders/configuration/introduction.html
 * and https://docs.magicmirror.builders/modules/configuration.html
 *
 * You can use environment variables using a `config.js.template` file instead of `config.js`
 * which will be converted to `config.js` while starting. For more information
 * see https://docs.magicmirror.builders/configuration/introduction.html#enviromnent-variables
 */
let config = {
	address: "0.0.0.0",	// Address to listen on, can be:
							// - "localhost", "127.0.0.1", "::1" to listen on loopback interface
							// - another specific IPv4/6 to listen on a specific interface
							// - "0.0.0.0", "::" to listen on any interface
							// Default, when address config is left out or empty, is "localhost"
	port: 8080,
	basePath: "/",	// The URL path where MagicMirror² is hosted. If you are using a Reverse proxy
									// you must set the sub path here. basePath must end with a /
	ipWhitelist: [],	// Set [] to allow all IP addresses
									// or add a specific IPv4 of 192.168.1.5 :
									// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.1.5"],
									// or IPv4 range of 192.168.3.0 --> 192.168.3.15 use CIDR format :
									// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.3.0/28"],

	useHttps: false,			// Support HTTPS or not, default "false" will use HTTP
	httpsPrivateKey: "",	// HTTPS private key path, only require when useHttps is true
	httpsCertificate: "",	// HTTPS Certificate path, only require when useHttps is true

	language: "fr",
	locale: "en-US",   // this variable is provided as a consistent location
			   // it is currently only used by 3rd party modules. no MagicMirror code uses this value
			   // as we have no usage, we  have no constraints on what this field holds
			   // see https://en.wikipedia.org/wiki/Locale_(computer_software) for the possibilities

	logLevel: ["INFO", "LOG", "WARN", "ERROR"], // Add "DEBUG" for even more logging
	timeFormat: 24,
	units: "metric",

	modules: [
		{
			module: "alert",
		},
		{
			module: "newsfeed",
			position: "top_bar",
			config: {
				feeds: [
					{
						title: "RTS",
						url: "REDACTED_URL"
					}
				],
				showSourceTitle: false,
				showPublishDate: false,
				broadcastNewsFeeds: true,
				broadcastNewsUpdates: true
			}
		},
		{
			module: "clock",
			position: "top_bar"
		},
		{
			module: 'netatmo',
			position: 'top_left',
			header: 'Météo',
			config: {
				clientId: 'REDACTED_CLIENT_ID',
				clientSecret: 'REDACTED_CLIENT_SECRET',
				refresh_token: 'REDACTED_REFRESH_TOKEN', 
				showModuleNameOnTop: true,
				design: "bubbles"
			}
		},
		{
			module: "MMM-GoogleSheets",
			header: "Liste courses",
			position: "top_center",
			config: {
				url: "REDACTED_URL",
				sheet: "Courses",
				range: "auto",
				cellStyle: "invert",
				stylesFromSheet: ["font-size", "text-align", "font-style", "width", "height", "text-decoration"]
			}
		},
		{
			module: "MMM-GoogleSheets",
			header: "Menu de la semaine",
			position: "top_right",
			config: {
				url: "REDACTED_URL",
				sheet: "Menu",
				range: "A1:C8",
				cellStyle: "invert",
				stylesFromSheet: ["font-size", "text-align", "font-style", "width", "height", "text-decoration"]
			}
		},
		{
			module: "MMM-CalendarExt3",
			position: "bottom_bar",
			title: "Calendrier",
			config: {
				mode: "week",
				instanceId: "basicCalendar",
				locale: 'fr-CH',
				weekIndex: 0,
				weeksInView: 4,
				maxEventLines: 5,
				firstDayOfWeek: 1,
				calendarSet: ['gerber', 'feries']
			}
		},
		{
			module: "calendar",
			config: {
        		broadcastPastEvents: true, 
				calendars: [
					{
						symbol: "calendar-check",
						url: "REDACTED_URL",
						name: "gerber",
            			color: "orange"
					}
				],	
			}	
		},
		{
			module: "calendar",
			config: {
        		broadcastPastEvents: true, 
				calendars: [
					{
						symbol: "calendar-check",
						url: "REDACTED_URL",
						name: "feries",
            			color: "green"
					}
				],	
			}	
		},
		{
		 	module: "updatenotification",
			position: "bottom_bar"
		},
		// {
		// 	module: "MMM-ModulePosition",
		// 	position: "fullscreen_below",
		// },
	]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") { module.exports = config; }
