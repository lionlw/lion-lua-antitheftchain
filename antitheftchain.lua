-- ���ܣ����ط�����
-- /wapvideo/47bce5c74f589f4867dbd57e9ca9f808/111/222/aaa.mp4
-- md5:47bce5c74f589f4867dbd57e9ca9f808
-- realurl:/111/222/aaa.mp4
-- filename:aaa.mp4

-- ����ֵ 0:������֤ʧ�� 1:������֤�ɹ� 2:����Ҫ����



local debug = tonumber(ngx.arg[1]);			-- debug���� 0:��ʽ 1:debug
local confusetime = tonumber(ngx.arg[2]); 	-- ·��MD5��������1 0:��ʹ�� 1:ÿСʱ 2:ÿ�� 3:ÿ��
local confusetype = tonumber(ngx.arg[3]);	-- ·��MD5��������2 0:�������ļ������� 1:�����ļ�������
local confusetext = ngx.arg[4];				-- ������
local filefolder = ngx.arg[5];				-- �����ļ�Ŀ¼��


if confusetime == 0 then
        return 2;
end;

--��ȡ���º�����
function GetPreNextMonth(curyearmonth, type)
        local year = tonumber(string.sub(curyearmonth, 1, 4));
        local month = tonumber(string.sub(curyearmonth, 5, 6));

        local fyear;
        local fmonth;

        if type == 1 then
                fmonth = month - 1;
                if fmonth == 0 then
					fyear = year - 1;
					fmonth = 12;
                else
					fyear = year;
                end;
        elseif type == 2 then
                fmonth = month + 1;
                if fmonth == 13 then
					fyear = year + 1;
					fmonth = 1;
                else
					fyear = year;
                end;
        end;

        if fmonth < 10 then
                fmonth = "0"..fmonth;
        end;

        return fyear..fmonth;
end;


local urltemp = (string.gsub(ngx.var.uri, "/"..filefolder.."/", ""));
local md5old = string.sub(urltemp, 1, (string.find(urltemp, "/")) - 1);
local realurl = (string.gsub(urltemp, md5old, ""));
local filename;

--��ȡ�ļ���
if confusetype == 1 then
        local i = 0;
        local pos;
        while true do
                i = string.find(realurl, "/", i+1);
                if i == nil then
					break;
                else
					pos = i;
                end;
        end;

        if pos ~= nil then
                filename = string.sub(realurl, pos+1);
        end;
else
	filename = "";
end;

if filename == nil then
        return 0;
end;

local curtime = os.time();
local checktextcur;
local checktextpre;
local checktextnext;

if confusetime == 1 then
        checktextcur = os.date("%Y%m%d%H", curtime);
        checktextpre = os.date("%Y%m%d%H", curtime-3600);
        checktextnext = os.date("%Y%m%d%H", curtime+3600);
elseif confusetime == 2 then
        checktextcur = os.date("%Y%m%d", curtime);
        checktextpre = os.date("%Y%m%d", curtime-86400);
        checktextnext = os.date("%Y%m%d", curtime+86400);
elseif confusetime == 3 then
        checktextcur = os.date("%Y%m", curtime);
        checktextpre = GetPreNextMonth(checktextcur, 1);
        checktextnext = GetPreNextMonth(checktextcur, 2);
else
        return 0;
end;


if debug==1 then
		local a1 = ngx.md5(checktextcur..filename..confusetext);
		local a2 = ngx.md5(checktextpre..filename..confusetext);
		local a3 = ngx.md5(checktextnext..filename..confusetext);
		return checktextcur..filename..confusetext.." "..a1.."|"..a2.."|"..a3.." "..md5old;
end;

--�ж��Ƿ���ͬ
if md5old == ngx.md5(checktextcur..filename..confusetext) then
        return 1;
elseif md5old == ngx.md5(checktextpre..filename..confusetext) then
        return 1;
elseif md5old == ngx.md5(checktextnext..filename..confusetext) then
        return 1;
else
        return 0;
end;
