<cfoutput>
	<cfif rc.itemValuationMountaineersData.recordcount>
		<cfset UNItotal = 0>
		<cfset EXPtotal = 0>
		<cfset GrandTotal = 0>
		<cfset i = 1>
		<cfif not structKeyExists(url, "print")>
		<p><a href="#buildUrl('main.itemValuationMountaineers&print')#">Print View</a><p>
		<table class="table table-condensed table-bordered table-striped">
			<tr class="error">
				<td>Records in red indicated that the sku does not have a unit cost value entered!</td>
			</tr>
		</table>
		</cfif>
		<cfif structKeyExists(url, "print")>
		<style>
			table {
				border-collapse: collapse;
			}
			table, th, tr, td  { 
				border: 1px solid LightGray;
			}
			thead {
				display: table-header-group;
			}
			a:link, a:visited {
    			text-decoration: none; 
				color: black;
			}
		</style>
		<p><strong>Item Valuation for Mountaineers Stock Report</strong> printed on #DateFormat(Now(), "m/d/yyyy")#</p>
		</cfif>	
		<table class="table table-condensed table-bordered table-striped">
			<thead>
			<tr>
				<th>Item No.</th>
				<th>Item Name</th>
				<th>Mountaineers Off Site Amount</th>
				<th>Unit Cost</th>
				<th>Extended Cost</th>
			</tr>
			</thead>
			<cfset prefix = "">
			<cfloop query="rc.itemValuationMountaineersData">
					<cfif unitCost eq "">
						<cfset theClass = "error">
					<cfelse>
						<cfset theClass = "">
					</cfif>	
					<tr class="#theClass#">
						<td>#skuCode#</a></td>
						<td><a href="/Slatwall/?slatAction=entity.editproduct&productID=#productID#">#productName# <cfif optionName neq "">-</cfif> #optionName#</a></td>
						<td>#skuQATS#</td>
						<td>#dollarFormat(unitCost)#</td>
						<td>#dollarFormat(extendedCost)#</td>	
					</tr>
				<cfset UNItotal = UNItotal + numberFormat(unitCost) />
				<cfset EXPtotal = EXPtotal + extendedCost />
				<cfset GrandTotal = GrandTotal + extendedCost />
				<cfset i = i +1>
			</cfloop>
			<tr class="TOTALROW">
				<td colspan="2">&nbsp;</td>
				<td>Mountaineers totals:</td>
				<td align="right">#DollarFormat(UNItotal)#</td>
				<td align="right">#DollarFormat(EXPtotal)#</td>
			</tr>
			<tr bgcolor="##000000" class="TINYTEXT">
				<td colspan="5" height="1">&nbsp;</td>
			</tr>
			<tr class="TOTALROW">
				<td colspan="4" align="right">Total Mountaineers Extended Costs:</td>
				<td align="right">#DollarFormat(grandTotal)#</td>
			</tr>
		
	<cfelse>
		<p class="alert alert-danger">No records exist for the criteria defined!</p>
	</cfif>
</cfoutput>