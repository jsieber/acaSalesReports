/*

 Adventure Cycling Association
 John Sieber 8/5/2014
 Integration for ACA Sales Reports

Notes:

*/
component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	public any function init() {
		return this;
	}
	
	public string function getIntegrationTypes() {
		return "fw1";
	}
	
	public string function getDisplayName() {
		return "ACA Sales Reports";
	}
	
	public struct function getSettings() {
		var settings = {
			// OrderID = {fieldType="text"} 
		};
		
		return settings;
	}
	
}