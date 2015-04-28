<cfoutput>
<!--- <cfif not structKeyExists(rc, "submit")>
		
	<form name="rc.itemValuation" action="?s=1">
		<fieldset>
			<legend>Item Valuation Report<legend>
			<label for="startNumber">Start Number</label>
			<input type="text" name="startNumber" value="">
			<label for="endNumber">End Number</label>
			<input type="text" name="endNumber" value="">
			<label></label>
			<input type="hidden" name="slatAction" value="aca_SalesReports:main.itemValuation" />
			<button type="submit" name="submit" class="btn btn-primary">Submit</button>
		</fieldset>
	</form>

<cfelse> --->
	<cfif rc.itemValuationData.recordcount>
		<!--- <cfdump var="#rc.itemValuationData#"> --->
		<cfset UNItotal = 0>
		<cfset EXPtotal = 0>
		<cfset GrandTotal = 0>
		<cfset i = 1>
		<cfif not structKeyExists(url, "print")>
		<p><a href="#buildUrl('main.itemValuation&print')#">Print View</a><p>
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
		<p><strong>Item Valuation Report</strong> printed on #DateFormat(Now(), "m/d/yyyy")#</p>
		</cfif>	
		<table class="table table-condensed table-bordered table-striped">
			<!---<tr>
				<th colspan="6" align="right">Reorder Items</th>
			</tr>--->
			<thead>
			<tr>
				<th>Item No.</th>
				<th>Item Name</th>
				<th>Vendor No. and Name</th>
				<th>Amount On Hand</th>
				<th>Unit Cost</th>
				<th>Extended Cost</th>
			</tr>
			</thead>
			<cfset prefix = "">
			<cfloop query="rc.itemValuationData">
				<cfif mid(skuCode,1,2) NEQ prefix>
					<cfif i NEQ 1>
						<tr class="TOTALROW">
							<td colspan="3">&nbsp;</td>
							<td>#prefix# totals:</td>
							<td align="right">#DollarFormat(UNItotal)#</td>
							<td align="right">#DollarFormat(EXPtotal)#</td>
								<cfset UNItotal = 0>
								<cfset EXPtotal = 0>
						</tr>
					</cfif>
					<cfset prefix = mid(skuCode,1,2)>
					<tr>
						<td colspan="6"><B>#prefix#</B></td>
					</tr>
				</cfif>
					<cfif unitCost eq "">
						<cfset theClass = "error">
					<cfelse>
						<cfset theClass = "">
					</cfif>	
					<tr class="#theClass#">	
						<td><a href="/Slatwall/?slatAction=entity.editsku&skuID=#skuID#">#skuCode#</a></td>
						<td><a href="/Slatwall/?slatAction=entity.editproduct&productID=#productID#">#productName# <cfif optionName neq "">-</cfif> #optionName#</a></td>
						<td><!--- Can't link to vendor unless vendor orders exist and it might change ---></td>
						<td>#skuQATS#</td>
						<td>#dollarFormat(unitCost)#</td>
						<td>#dollarFormat(extendedCost)#</td>	
					</tr>
				<cfset UNItotal = UNItotal + numberFormat(unitCost) />
				<cfset EXPtotal = EXPtotal +extendedCost />
				<cfset GrandTotal = GrandTotal + extendedCost />
				<cfset i = i +1>
			</cfloop>
			<tr class="TOTALROW">
				<td colspan="3">&nbsp;</td>
				<td>#prefix# totals:</td>
				<td align="right">#DollarFormat(UNItotal)#</td>
				<td align="right">#DollarFormat(EXPtotal)#</td>
					<cfset UNItotal = 0>
					<cfset EXPtotal = 0>
			</tr>
			<tr bgcolor="##000000" class="TINYTEXT">
				<td colspan="6" height="1">&nbsp;</td>
			</tr>
			<tr class="TOTALROW">
				<td colspan="5" align="right">Total Extended Costs:</td>
				<td align="right">#DollarFormat(grandTotal)#</td>
			</tr>
		
	<cfelse>
		<p class="alert alert-danger">No records exist for the criteria defined!</p>
	</cfif>
<!--- </cfif> --->
</cfoutput>