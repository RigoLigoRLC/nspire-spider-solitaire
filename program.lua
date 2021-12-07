--[[
nSpire Spider Solitaire
Author: RigoLigo 2020
License: Public Domain

Use Up to select multiple cards
Use Enter to begin and end a move
Use Return key to add cards
Use Delete key to undo
]]

function placable1()if #grid[sc]==0 then return false end if #grid[tp]==0 then return true end if tdt(grid[tp][#grid[tp]],13)-tdt(grid[sc][#grid[sc]-sn+1],13)==1 then return true else return false end end
function placable2()return placable1()end
function placable3()if #grid[sc]==0 then return false end if #grid[tp]==0 then return true end if tdt(grid[tp][#grid[tp]],13)-tdt(grid[sc][#grid[sc]-sn+1],13)==1 and color(grid[sc][#grid[sc]-sn+1])~=color(grid[tp][#grid[tp]])then return true else return false end end
function movable1(c,s,e)if s==e then return true end a=grid[c][s]for i=s+1,e do if tdt(a,13)-tdt(grid[c][i],13)~=1 then return false else a=grid[c][i] end end return true end
function movable2(c,s,e)if s==e then return true end a=grid[c][s]b=color(grid[c][s])for i=s+1,e do if tdt(a,13)-tdt(grid[c][i],13)~=1 and color(grid[c][i])~=b then return false else a=grid[c][i] end end return true end
function movable3(c,s,e)if s==e then return true end a=grid[c][s]b=color(grid[c][s])for i=s+1,e do if tdt(a,13)-tdt(grid[c][i],13)~=1 and color(grid[c][i])==b then return false else a=grid[c][i]b=color(grid[c][i]) end end return true end

p_={placable1,placable2,placable3}
m_={movable1,movable2,movable3}

d_=1
placable=p_[d_]movable=m_[d_]
map={"A",2,3,4,5,6,7,8,9,10,"J","Q","K"}
n=true
--n=false
sc=1 sn=1 tp=1 mv=false won=false
maxundo=20
--vis[6]={true}
if n then
grid={}for i=1,10 do table.insert(grid,{}) end
idle={}for i=1,10 do table.insert(idle,{}) end
stack={}vis={}uds={}udis={}
end

function clear()
grid={}for i=1,10 do table.insert(grid,{}) end
idle={}for i=1,10 do table.insert(idle,{}) end
stack={}vis={}uds={}udis={}
end
function newround()
if n then clear()end
for i=1,156 do stack[i]=false end
for i=1,56 do a=math.random(1,156)while stack[a]==true do a=math.random(1,156)end stack[a]=true table.insert(grid[tdt(i,10)],a)end
for i=1,10 do table.insert(vis,{})for j=1,#grid[i] do if j==#grid[i] then vis[i][j]=true else vis[i][j]=false end end end
for i=1,10 do for j=1,10 do a=math.random(1,156)while stack[a]==true do a=math.random(1,156)end stack[a]=true table.insert(idle[j],a)end end
end


function on.construction()
if n then newround() end
--grid[1]={13,12,11,10,9,8,7,6,5,4,3,2}
--grid[2]={2}vis[2]={true}
--vis[1]={true,true,true,true,true,true,true,true,true,true,true,true}
--vis[2]={true}grid[2]={1}
end
function on.returnKey()
newpile()
platform.window:invalidate()
end

function on.paint(gc)
if won then gc:drawString("Press enter to start another game",20,120) gc:setFont("sansserif","b",20)gc:drawString("You Won!",20,100)return end

gc:setFont("sansserif","r",9)
--newround()
gc:drawString(#idle--..","..,
,1,190)
gc:drawString(var.recall("dbg"),1,212)
for i=1,10 do y=2 for j=1,#grid[i] do
if vis[i][j] then
if d_~=1 then gc:setColorRGB(color(grid[i][j]),0,0)end
gc:drawString(map[tdt(grid[i][j],13)],20*i+1,y-3)
if d_~=1 then gc:setColorRGB(0,0,0)end
gc:drawRect(20*i,y,16,12)y=y+12
else gc:drawRect(20*i,y,16,2) y=y+2 end
end end
--for i=1,#idle do for j=1,10 do gc:drawString(tdt(idle[i][j],13),20*i,100+10*j)end end

gc:setPen("medium")
gc:setColorRGB(255,0,0)
y=2 for i=1,#vis[sc]-sn do if not vis[sc][i] then y=y+2 else y=y+12 end end
gc:drawRect(sc*20-1,y-1,17,1+12*sn)
if mv then
gc:setColorRGB(0,0,0)y=13
for i=1,#vis[tp] do if not vis[tp][i] then y=y+2 else y=y+12 end end
if #vis[tp]==0 then y=14 else y=y-11 end
gc:drawRect(tp*20-1,y-13,17,13)
end
end

function on.enterKey()
if won then won=false clear()newround() end
if mv then move() else mv=true tp=sc end
win()
platform.window:invalidate()
end

function on.backspaceKey()
undo()
end

function on.arrowKey(a)
if a=="up" then if #grid[sc]==sn then return end if #grid[sc]==0 then return end if movable(sc,#grid[sc]-sn,#grid[sc]) and vis[sc][#vis[sc]-sn]==true and not mv then sn=sn+1 end
elseif a=="down" then if sn>1 and not mv then sn=sn-1 end
elseif a=="left" then
 if mv then if tp>1 then tp=tp-1 else tp=10 end else if sc>1 then sc=sc-1 else sc=10 end sn=1 end
elseif a=="right" then
 if mv then if tp<10 then tp=tp+1 else tp=1 end else if sc<10 then sc=sc+1 else sc=1 end sn=1 end
end
platform.window:invalidate()
end

function on.tabKey()
--a=sn
for i=1,#grid[sc]-1 do
--a=sn
if #grid[sc]==sn then break end
 if #grid[sc]==0 then return end if movable(sc,#grid[sc]-sn,#grid[sc]) and vis[sc][#vis[sc]-sn]==true then sn=sn+1 end
end
platform.window:invalidate()
end

function move()
a=placable()
var.store("dbg","nil")
if a then
 --for i=#grid[sc]-sn+1,#grid[sc] do
 x=#grid[sc]-sn+1
 logundo()
 for i=1,sn do
  table.insert(grid[tp],grid[sc][x])
  table.remove(grid[sc],x)
  table.insert(vis[tp],vis[sc][x])
  table.remove(vis[sc],x)
 end
 vis[sc][#vis[sc]]=true sn=1
 finish()
 sc=tp
end
mv=false

end

function logundo()
if #uds>=maxundo then table.remove(uds,1) end
 table.insert(uds,{0,0,{},{},{},{}})
 uds[#uds][1]=sc uds[#uds][2]=tp
 for i=1,#grid[sc] do
  table.insert(uds[#uds][3],grid[sc][i])
  table.insert(uds[#uds][4],vis[sc][i])
 end
 for i=1,#grid[tp] do
  table.insert(uds[#uds][5],grid[tp][i])
  table.insert(uds[#uds][6],vis[tp][i])
 end
end

function undo()
if #uds==0 then return end
if uds[#uds]=="newpile" then
 table.insert(idle,1,{})
 for i=1,10 do
  table.insert(idle[1],grid[i][#grid[i]])
  table.remove(grid[i],#grid[i])
  table.remove(vis[i],#vis[i])
 end
 table.remove(uds,#uds)
 platform.window:invalidate()
 return
end
 sc_=uds[#uds][1]tp_=uds[#uds][2]
 grid[sc_]={} grid[tp_]={}
 vis[sc_]={} vis[tp_]={}
 for i=1,#uds[#uds][3] do
  table.insert(grid[sc_],uds[#uds][3][i])
 end
 for i=1,#uds[#uds][4] do
  table.insert(vis[sc_],uds[#uds][4][i])
 end
 for i=1,#uds[#uds][5] do
  table.insert(grid[tp_],uds[#uds][5][i])
 end
 for i=1,#uds[#uds][6] do
  table.insert(vis[tp_],uds[#uds][6][i])
 end
table.remove(uds,#uds)
platform.window:invalidate()
end

function finish()
d=""
a=0 for i=1,#grid[tp]do if vis[tp][i] then a=a+1 end end if a<13 then return end
if #grid[tp]<13 then return end a=grid[tp][#grid[tp]]for i=#grid[tp]-1,#grid[tp]-12,-1 do if tdt(grid[tp][i],13)-tdt(a,13)~=1 then var.store("dbg",i) return  else a=grid[tp][i] end end for i=1,13 do table.remove(grid[tp],#grid[tp])table.remove(vis[tp],#vis[tp])sn=1 end
if #grid[tp]>0 then vis[tp][#vis[tp]]=true end
end

function color(a)b=math.fmod(math.floor(a/13),4)if b==0 or b==2 then return 255 else return 0 end end
function win()for i=1,10 do if #grid[i]~=0 then return end end won=true end
function newpile()if #idle~=0 then if #uds>maxundo then table.remove(uds,1) end table.insert(uds,"newpile") for i=1,10 do table.insert(grid[i],idle[1][i]) table.insert(vis[i],true)end table.remove(idle,1)end sn=1 end
function tdt(a,t)b=a while b>t do b=b-t end return b end
