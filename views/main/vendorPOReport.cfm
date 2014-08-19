<cfoutput>
<cfif not structKeyExists(rc, "submit")>
		
	<form name="rc.vendor" action="?s=1">
		<fieldset>
			<legend>Vendor Purchase Order Report<legend>
			<label for="vendorName">Vendor Account ##</label>
			<input type="text" name="vendorName" value="">
			<label for="vendorSelect">Or Select Vendor</label>
			<select name="vendorSelect">
				<option value="">Select a Vendor</option>
				<cfloop query="rc.vendorList">
					<option value="#vendorID#">#vendorName# - #accountNumber#</option>
				</cfloop>
			</select>
			<label></label>
			<input type="hidden" name="slatAction" value="aca_SalesReports:main.vendorPOReport" />
			<button type="submit" name="submit" class="btn btn-primary">Submit</button>
		</fieldset>
	</form>

<cfelse>
	<cfif rc.vendorPoList.recordcount>
		<table class="table table-condensed table-bordered table-striped">
			<tr>
				<th colspan="5" align="right">Vendor Purchase Orders</th>
			</tr>
			<tr>
				<td>Purchase Order No.</td>
				<td>Date Created</td>
				<td>Total Amount</td>
				<td>Status</td>
				<td>Link</td>
			</tr>
			
			<cfloop query="rc.vendorPoList">
				<!--- Setup Status and row class --->
				<cfif totalOrderQuantityReceived lt totalOrderQuantity>
					<cfset local.rowClass = "error">
					<cfset local.status = "Open">
				<cfelse>
					<cfset local.rowClass = "info">
					<cfset local.status = "Closed">
				</cfif>
				<tr class="#local.rowClass#">
					<td>#vendorOrderNumber#</td>
					<td>#dateFormat(createdDateTime, "medium")# #timeFormat(createdDateTime, "medium")#</td>
					<td>#dollarFormat(OrderCost)#</td>
					<td>#local.status#</td>
					<td><a href="/Slatwall/?slatAction=entity.detailvendororder&vendorOrderID=#vendorOrderID#">View</a></td>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		<p class="alert alert-danger">There are no purchase orders for this vendor!</p>	
	</cfif>
</cfif>



</cfoutput>