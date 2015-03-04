local Unit = require 'Object.Unit'
local Player = class("Creature",Unit)
Player.__index = Player

function Player:ctor(info)
	Unit.ctor(self,info,PlayerType)
end

function Player:addToWorld(map,pos,face,ai)
	self:setMap(map)
	self:setPos(pos)
	self:setAI(ai)
	self:setDir(cc.p(face,0))
	self._face=face
	self._map:addPlayer(self,1)
	--self._schedule = sharedDirector:getScheduler():scheduleScriptFunc(handler(self,self._update),0,false)
	self._addToWorld = true
end

return Player