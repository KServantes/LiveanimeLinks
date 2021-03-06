--同胞の絆
function c100000478.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000478.cost)
	e1:SetTarget(c100000478.target)
	e1:SetOperation(c100000478.activate)
	c:RegisterEffect(e1)
end
function c100000478.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100000478.filter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c100000478.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetRace())
end
function c100000478.spfilter(c,e,tp,race)
	return c:IsLevel(4) and c:IsRace(race) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000478.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000478.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100000478.activate(e,tp,eg,ep,ev,re,r,rp)
	local race=0
	for c in aux.Next(Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)) do
		race=race|c:GetRace() 
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c100000478.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,race)
	if ft<1 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=Group.CreateGroup()
	while sg:GetCount()<math.min(ft,2) do
		local cancel=sg:GetCount()>0
		local cg=g
		if sg:GetCount()>0 then
			cg=g:Filter(Card.IsRace,sg:GetFirst(),sg:GetFirst():GetRace())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Group.SelectUnselect(cg,sg,tp,cancel,cancel,1,2)
		if not tc then break end
		if not sg:IsContains(tc) then
			sg:AddCard(tc)
		else
			sg:RemoveCard(tc)
		end
	end
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e3)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end