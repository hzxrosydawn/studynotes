<html>
<head>
    <title></title>
    <style type="text/css">
        table
        {
            border-collapse: collapse;
            margin: 0 auto;
            text-align: center;
        }
        table td, table th
        {
            border: 1px solid #cad9ea;
            color: #666;
            height: 30px;
        }
        table thead th
        {
            background-color: #CCE8EB;
            width: 100px;
        }
        table tr:nth-child(odd)
        {
            background: #fff;
        }
        table tr:nth-child(even)
        {
            background: #F5FAFA;
        }
    </style>
</head>
<body>
<h3>集团人脸库从 ${fromTime} 至 ${toTime} 时间范围内的失败操作记录如下表所示：</h3>
<table width="90%" class="table">
    <thead>
    <tr>
        <th>
            编号
        </th>
        <th>
            来源端
        </th>
        <th>
            操作
        </th>
        <th>
            序列号
        </th>
        <th>
            开始时间
        </th>
        <th>
            操作内容
        </th>
        <th>
            操作端
        </th>
        <th>
            完成代码
        </th>
        <th>
            完成消息
        </th>
        <th>
            生成内容
        </th>
        <th>
            完成时间
        </th>
        <th>
            完成结果
        </th>
        <th>
            结果描述
        </th>
        <th>
            主机IP
        </th>
    </tr>
    </thead>
    <#list failedOptLogList as requestLog>
        <tr>
            <td>
            ${requestLog?counter}
            </td>
            <td>
            ${requestLog.sourceEnd.sysDesc}
            </td>
            <td>
            ${requestLog.transNum.transNumDesc}
            </td>
            <td>
            ${requestLog.optSeqNum}
            </td>
            <td>
            ${requestLog.startTime?string('yyyy-MM-dd HH:mm:ss')}
            </td>
            <td>
                <#if requestLog.sourceEntity??>
                    ${requestLog.sourceEntity}
                <#else></#if>
            </td>
            <td>
            ${requestLog.optEnd.sysDesc}
            </td>
            <td>
                <#if requestLog.doneCode??>
                    ${requestLog.doneCode}
                <#else></#if>
            </td>
            <td>
                <#if requestLog.doneMsg??>
                ${requestLog.doneMsg}
                <#else></#if>
            </td>
            <td>
                <#if requestLog.doneEntity??>
                ${requestLog.doneEntity}
                <#else></#if>
            </td>
            <td>
                <#if requestLog.doneTime??>
                ${requestLog.doneTime?string('yyyy-MM-dd HH:mm:ss')}
                <#else></#if>
            </td>
            <td>
            ${requestLog.doneResult}
            </td>
            <td>
            ${requestLog.doneDesc}
            </td>
            <td>
            ${requestLog.localHost}
            </td>
        </tr>
    </#list>
</html>