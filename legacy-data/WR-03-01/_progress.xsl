<?xml version='1.0'?>
<xsl:stylesheet
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns="http://www.w3.org/1999/xhtml"
			version="1.0">

			<xsl:output method="html"/>

			<xsl:template match="/">

			<HTML>
						<HEAD>
										<SCRIPT LANGUAGE="Javascript1.2">
												var visi1 = false;
												var visi2 = false;
												var visi3 = false;
	
												function doSwitch() {
															if (visi1) {
																		visi1 = false;
																		document.all.div1.style.visibility = "visible";
																		
															} else {
																		visi1 = true;
																		document.all.div1.style.visibility = "hidden";
															}
															setTimeout('doSwitch()', 300);
															
												}
		
												function doSwitch1() {
															if (visi2) {
																		visi2 = false;
																		document.all.div2.style.visibility = "visible";
																		
															} else {
																		visi2 = true;
																		document.all.div2.style.visibility = "hidden";
															}
															setTimeout('doSwitch1()', 400);
															
												}
		
												function doSwitch2() {
															if (visi3) {
																		visi3 = false;
																		document.all.div3.style.visibility = "visible";
																		
															} else {
																		visi3 = true;
																		document.all.div3.style.visibility = "hidden";
															}
															setTimeout('doSwitch2()', 500);
															
												}
									</SCRIPT>
									
									<STYLE type="text/css">
												BODY {
															background: rgb(250,255,217);
												}
												
												TABLE {
															border-collapse: collapse;
															border-color: rgb(170,0,0);
															border-width: 1px;
															border-style: solid;
												}
												
												TABLE.t1 {
															position: absolute; 
															left: 20px; 
															top: 100px;
												}
												
												TD {
															border: 1px solid black;
															padding: 3px 3px 3px 3px;
															vertical-align: top;
															background: rgb(247,255,183);
												}
												
												TD.td1 {
															border: 0px solid green;
															vertical-align: top;
															background: rgb(250,255,217);
															font-size: 35px;
															color: rgb(170,0,0);
												}
												
												TD.header {
															background: rgb(170,0,0);
															color: white;
															font-weight:bold;
												}
												
												TD.pref {
															background: rgb(0,125,0);
															color: white;
															font-weight:bold;
															width:300px;
												}
												
												TD.pref1 {
															background: rgb(0,125,0);
															color: white;
															font-weight:bold;
															width:200px;
												}
											
									</STYLE>
						</HEAD>
						<BODY onLoad="doSwitch();doSwitch1();doSwitch2();">

									<TABLE style="border:0px;background:rgb(250,255,217);position:absolute;left:30px;top:20px;">
												<TR><TD class="td1"><DIV id="div1" style="visibility:visible;">&#x2590;</DIV></TD><TD class="td1"><DIV id="div2" style="visibility:visible;">&#x25CF;</DIV></TD><TD class="td1"><DIV id="div3" style="visibility:visible;">&#x25BA;</DIV></TD></TR>
									</TABLE>
									
									<TABLE style="position:absolute;left:170px;top:17px;">
												<TR><TD class="pref1">DIRECTORY</TD><TD colspan="5"><xsl:value-of select="//DIRECTORY"></xsl:value-of></TD></TR>
												<TR><TD class="pref1">FILES</TD><TD colspan="5"><xsl:value-of select="//DATAFILES"></xsl:value-of></TD></TR>
								</TABLE>
								
								<BR/>				
								
								<TABLE class="t1">
									<!-- *********************************************** -->
									<!-- ********* HEADER ****************************** -->
									<!-- *********************************************** -->
									<TR>
												<TD class="header">Task</TD>
												<TD class="header">Done</TD>
												<TD class="header">Date</TD>
												<TD class="header">Assigned</TD>
												<TD class="header">Resp.</TD>
												<TD class="header">Comm.</TD></TR>
									
									<!-- *********************************************** -->
									<!-- ********* DATA  ******************************* -->
									<!-- *********************************************** -->
									<xsl:for-each select="//WORKFLOW/*">
												<TR>
															<TD class="pref"><xsl:value-of select="name()"/></TD>
															<TD><xsl:value-of select="DONE"/></TD>
															<TD><xsl:value-of select="DATE"/></TD>
															<TD><xsl:value-of select="ASSIGNED"/></TD>
															<TD><xsl:value-of select="RESP"/></TD>
															<TD><xsl:value-of select="COMM"/></TD>
												</TR>
									</xsl:for-each>									
						</TABLE>						

						</BODY>
			</HTML>

	</xsl:template>

</xsl:stylesheet>
