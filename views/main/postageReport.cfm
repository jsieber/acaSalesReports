<cfoutput>
<cfif not structKeyExists(rc, "postageReportStartDate")>
	<!--- Default date values --->
	<cfset currentDate = dateFormat(now(), "m/d/yyyy") />
	<cfset currentCalendarDay = datePart("d", currentDate) />
	<cfset postageReportEndDate = dateAdd("m", -1, currentDate) />
	<cfset postageReportEndDate = dateAdd("d", -currentCalendarDay, currentDate) />
	<cfset daysInMonth = datePart("d", postageReportEndDate) - 1 />
	<cfset postageReportStartDate = dateAdd("d", -daysInMonth, postageReportEndDate) />
	<p>Please select start and end dates for this report.</p>
	<form action="?s=1" name="bestItemsReportDates">
		<div class="form-group">
			<label for="postageReportStartDate">Start Date</label>
			<input type="text" name="postageReportStartDate" id="postageReportStartDate" value="#dateFormat(postageReportStartDate, "m/d/yyyy")#">
		</div>
		<div class="form-group">
			<label for="postageReportEndDate">End Date</label>
			<input type="text" name="postageReportEndDate" id="postageReportEndDate" value="#dateFormat(postageReportEndDate, "m/d/yyyy")#">
		</div>
		<input type="hidden" name="slatAction" value="aca_SalesReports:main.postageReport" />
		<button type="submit" class="btn btn-primary">Submit</button>
	</form>
	
	<script>
 		$(function() {
   		$( "##bestItemsStartDate" ).datepicker();
   		$( "##bestItemsEndDate" ).datepicker();
 		});
 	</script>
<cfelse>
 <!--- <cfdump var="#rc#" top=2 abort=true>  --->
<h3>Order Counts</h3>
<table class="table table-condensed table-bordered table-striped" id="bestItemReport">
	<thead>
		<tr>
			<th>Date Range</th>
			<th>Order Type</th>
			<th>Count</th>
		</tr>
	</thead>
	
	<tbody>	
		<cfloop query="#rc.orderCountData#">
		<tr>
			<td><b>#rc.postageReportStartDate# - #rc.postageReportEndDate#</b></td>
			<td>#orderType#</td>
			<td>#orderIDCount#</td>
		</tr>
		</cfloop>
	</tbody>
</table>
<h3>Postage Amount</h3>
<table class="table table-condensed table-bordered table-striped" id="bestItemReport">
	<thead>
		<tr>
			<th>Date Range</th>
			<th>Postage Amount</th>
		</tr>
	</thead>
	
	<tbody>	
		<tr >
			<td ><b>#rc.postageReportStartDate# - #rc.postageReportEndDate#</b></td>
			<cfloop query="#rc.postageReportData#">
			<td>#dollarFormat(postageTotal)#</td>
			</cfloop>
		</tr>	
	</tbody>
</table>
</cfif>
</cfoutput>