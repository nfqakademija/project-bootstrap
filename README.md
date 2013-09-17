NFQ Akademija - Individualaus projekto infrastruktūra
========================

Installiacija
----------------------------------

Pasileisti infrastruktūra reikės įsidiegti [virtualbox](1) ir [vagrant](2). Įdiegus vagrant papildomai reikės įdiegti papildymą. Tai padaryti galite konsolėje iškvietę komandą:

    vagrant plugin install vagrant-hostsupdater
    
Tai sudiegę galime paleisti visą infrastruktūrą. Tai padarykite nueikite į projekto root direktoriją ir paleiskite komandą:

    vagrant up
    
Papildomai sudiegti paketus ar vėliau patikrinti pasiekitimus infrastruktūrai paleiskite komandą:

    vagrant provision
    
Prisijungti prie virtualios mašinos galima naudojant komandą:

    vagrant ssh
