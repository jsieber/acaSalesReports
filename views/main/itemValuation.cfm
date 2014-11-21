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
		
		<table class="table table-condensed table-bordered table-striped">
			<tr class="error">
				<td>Records in red indicated that the sku does not have a unit cost value entered!</td>
			</tr>
		</table>
		
		<table class="table table-condensed table-bordered table-striped">
			<tr>
				<th colspan="6" align="right">Reorder Items</th>
			</tr>
			<tr>
				<td>Item No.</td>
				<td>Item Name</td>
				<td>Vendor No. and Name</td>
				<td>Amount On Hand</td>
				<td>Unit Cost</td>
				<td>Extended Cost</td>
			</tr>
			<cfset prefix = "">
			<cfloop query="rc.itemValuationData">
				<cfif mid(skuCode,1,2) NEQ prefix>
					<cfif i NEQ 1>
						<tr>
							<td colspan="4"><b>#prefix# totals:</b></td>
							<td><b>#DollarFormat(UNItotal)#</b></td>
							<td><b>#DollarFormat(EXPtotal)#</b></td>	
						</tr>
						<cfset UNItotal = 0>
						<cfset EXPtotal = 0>
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
				<cfset EXPtotal = EXPtotal + extendedCost />
				<cfset GrandTotal = GrandTotal + extendedCost />
				<cfset i = i +1>
			</cfloop>
			<tr>
				<td colspan="4"><b>#prefix# totals:</b></td>
				<td><b>#DollarFormat(UNItotal)#</b></td>
				<td><b>#DollarFormat(EXPtotal)#</b></td>	
			</tr>
			<cfset UNItotal = 0 />
			<cfset EXPtotal = 0 />
			<tr >
				<td colspan="6">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5" ><b>Total Extended Costs:</b></td>
				<td><b>#DollarFormat(grandTotal)#</b></td>
			</tr>
		</table>
	<cfelse>
		<p class="alert alert-danger">No records exist for the criteria defined!</p>
	</cfif>
<!--- </cfif> --->
</cfoutput>