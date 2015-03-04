display = display or {}
cclog("required display module")
display.GameCache = import(".GameCache")
import(".NodeEx")
import(".SpriteEx")
--[[
    display保存一份所有shaders的表
    sprite使用shader时,都在此表中来查找,并自己克隆维护一份shader结构表
    shader的结构表为=
    {
      n, -- shader的名称,用于检索
      v, -- shader的顶点着色器,可以是代码片段,也可以是代码文件名
      f, -- shader的像素着色器,同参数v
    }
]]
display._scale = 1.0
display._wfactor = 1.0
display._hfactor = 1.0

display.shaders = {}

function display.addShader(shader)
    local name = shader.n
    local vsh = shader.v
    local fsh = shader.f
    local Program = display.getShader(name)
    if Program then return end
    local fileUtiles = cc.FileUtils:getInstance()
    if string.find(vsh,".vsh") ~= nil then
        vsh = fileUtiles:getStringFromFile( vsh )
    end

    if string.find(fsh,".fsh") ~= nil then
        fsh = fileUtiles:getStringFromFile( fsh )
    end
    Program = cc.GLProgram:createWithByteArrays( vsh, fsh )
    local GLProgramstate = cc.GLProgramState:create(Program)
    if GLProgramstate:getUniformCount() > 0 then
        display.shaders[name] = {v=vsh,f=fsh}
    else
        local ProgamCache = cc.GLProgramCache:getInstance()
        ProgamCache:addGLProgram( Program, name )
    end
    cclog("add shader : ".. name)
end

function display.getShader(name)
    local shader = display.shaders[name]
    if shader then
        local vsh = shader.v
        local fsh = shader.f
        local fileUtiles = cc.FileUtils:getInstance()
        if string.find(vsh,".vsh") ~= nil then
            vsh = fileUtiles:getStringFromFile( vsh )
        end

        if string.find(fsh,".fsh") ~= nil then
            fsh = fileUtiles:getStringFromFile( fsh )
        end
        Program = cc.GLProgram:createWithByteArrays( vsh, fsh )
        return Program
    else
        local ProgamCache = cc.GLProgramCache:getInstance()
        return ProgamCache:getGLProgram(name)
    end
end

function display:setDesgin(w,h)
    self._dw = w
    self._dh = h
end

function display:setFactor(w,h)
    if not self._dw or not self._dh then
        return
    end

    self._rw = w
    self._rh = h

    self._wfactor = self._dw / self._rw
    self._hfactor = self._dh / self._rh

    if self._wfactor > self._hfactor then
        self._scale = self._wfactor
    else
        self._scale = self._hfactor
    end
    local director = cc.Director:getInstance()
    director:setContentScaleFactor(self._scale)
end

function display:fitScreen(node)
    if not node or node == nil then
        return
    end

    local x = node:getScaleX()
    local y = node:getScaleY()
    if self._wfactor > self._hfactor then
        node:setScaleY(y/self._hfactor*self._scale) 
    else
        node:setScaleX(x/self._wfactor*self._scale)
    end
end

function uber.p(x,y)
    if type(x) == "table" and not y then
        y = x.y or 0
        x = x.x or 0
    end
    if display and display._scale and config.scaleByFactor then
        x = x/display._scale
        y = y/display._scale
    end
    return cc.p(x,y)
end

function uber.size(w,h)
    if display and display._scale then
        w = w/display._scale
        h = h/display._scale
    end
    return cc.size(w,h)
end

function pix(p)
    return p/display._scale
end

function display:debug()
    local str = string.format("当前分辨率:%dx%d  设计分辨率:%dx%d",self._rw,self._rh,self._dw,self._dh)
    return str
end