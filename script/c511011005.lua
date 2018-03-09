--Trick Barrier
--Keddy was here~
local id,cod=511011005,c511011005
function cod.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cod.target)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
end
function cod.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_MUST_BE_ATTACKED)
		e3:SetValue(1)
		e3:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(id,0))
		e4:SetCategory(CATEGORY_DRAW)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e4:SetCode(EVENT_LEAVE_FIELD)
		e4:SetLabelObject(tc)
		e4:SetCondition(cod.drcon)
		e4:SetTarget(cod.drtg)
		e4:SetOperation(cod.drop)
		Duel.RegisterEffect(e4,tp)
	end
end
function cod.dfilter(c,r,tp)
	return bit.band(r,0x21)~=0 and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cod.drcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetLabelObject() then return end
	return eg:IsExists(cod.dfilter,1,nil,r,tp)
end
function cod.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cod.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
