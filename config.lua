Config = {
    --[GENERAL]
    PetFollow = true, -- If true, the pet will follow the player, this is buggy at the moment.
    CanAttack = true, -- If true, the pet will attack peds. 
    AttackKey = 51, -- The key to attack the ped (E (default) = 51), refer to https://docs.fivem.net/docs/game-references/controls/ for keys. Only the key index is supported.
    MaxDistance = 100.0, -- The maximum distance the pet can attack from - the pet will not attack if the distance is greater than this.

    --[MARKER]
    Timeout = 45000, -- Time (in milliseconds) before the pet "fails attack" (if unsuccessful).
    ColorR = 255, -- Red color of the entity marker. (0 - 255)
    ColorG = 0, -- Green color of the entity marker. (0 - 255)
    ColorB = 0, -- Blue color of the entity marker. (0 - 255)
    Alpha = 100, -- Alpha color of the entity marker. (0 = invisible, 255 = fully visible)
}

Animals = {
    panther = "a_c_panther", 
    mountainlion = "a_c_mtlion", 
    retriever = "a_c_retriever",
    bulldog = "a_c_chop",
    cat = "a_c_cat_01",
    man = "a_m_m_mlcrisis_01", 
    
    --[[Pets that don't attack will just walk around for a couple of seconds.
    Add more animals here using https://docs.fivem.net/docs/game-references/ped-models/#animals and the format providing (dictionary).
    pigeon = "a_c_pigeon", --Avoid doing birds, they tend to fly away midway through anything and they can't attack.
    Human peds can attack too, but it's not recommended for a "pet script", is it now?]]
}

