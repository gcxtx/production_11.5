<%
    String userAgent = request.getHeader("User-Agent");
    if( userAgent != null && userAgent.indexOf("IE") >= 0 || userAgent.indexOf("rv:11.0") >= 0 ){
%>
		<object id="WebOffice" width="800" height="600" classid="clsid:8B23EA28-2009-402F-92C4-59BE0E063499" codebase="<%=rootPath%>/public/iWebOfficeSign/iWebOffice2009.cab#version=10,3,0,0" style="height:600" ></object>
<%}else{%>
		<object id="WebOffice" TYPE="application/kg-activex" ALIGN="baseline" BORDER="0" WIDTH="100%" HEIGHT="100%" clsid="{8B23EA28-2009-402F-92C4-59BE0E063499}"     copyright="同方全球人寿保险有限公司[专用];V5.0S0xGAAEAAAAAAAAAEAAAAEoBAABQAQAALAAAACpfuENiEFmnDq7i351d+KWy/6zD4aG6HD0z3GuzxFShu9gGRAXH1/jSfVk9wqGzF6U7PWkm2CrRi6jHcrjRWvHVQuHvIUU6JcGspdJY+wLfx+QaD8LfVNNQ8YscLBjuvcHm6HQYT0uVb+xa6YMT7gl5tvg0rXN4tX94Ni1heAdJOhqDjfZ6uPBwNb/tmfJMYtvkdPJOgd/IXRQM3RyJNQFmx+lJaMBtiIU6mamUiw2XX6ualk+x5vtQTswxLHbl9XCzhgxsg7DkPlLUVUgZYMO9rsMAurGCX1IWh8Rpq1Vr3/KdC4Wkrf6Xq8jXj86pNMzjJ4et91pWMMJv6hcMWxdILDxDYncJMIai4/r4EfwzNJSCK0Fzrn2gefvVkzoRWu/oAjmqZtzyLv4dwDszvyNqd93GjF64G5fdeDaHgrAaDMMnhGciuQdySMr+iCGF7VOsc9HAviyT95h6A8Z20iA="  OnMenuClick="OnMenuClick" OnToolsClick="OnToolsClick"></object>
<%}%>