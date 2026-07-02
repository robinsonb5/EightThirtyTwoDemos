module jtaggwrapper (
	output JTCK,
	output JTDI,
	output JSHIFT,
	output JUPDATE,
	output JRSTN,
	output JCE1,
	output JCE2,
	output JRTI1,
	output JRTI2,
	input JTDO1,
	input JTDO2
);

JTAGG jtagg_inst (
	.JTCK(JTCK),
	.JTDI(JTDI),
	.JSHIFT(JSHIFT),
	.JUPDATE(JUPDATE),
	.JRSTN(JRSTN),
	.JCE1(JCE1),
	.JCE2(JCE2),
	.JRTI1(JRTI1),
	.JRTI2(JRTI2),
	.JTDO1(JTDO1),
	.JTDO2(JTDO2)
);

endmodule
