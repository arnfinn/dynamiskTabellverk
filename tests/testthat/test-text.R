context("text")

test_that("correct text is returned", {
  originalverdier <- list(inpDatasett = testdata,
                          fane = "alle", #?
                          rad=c("boomr_hf","behandlende_hf"),
                          kol= "aar",
                          verdi="kontakter",
                          aar=2016,
                          bo=2,
                          beh=1,
                          behandlingsniva = c("Døgnopphold","Dagbehandling","Poliklinikk","Avtalespesialist"), #"Poliklinikk",
                          alder=c("tmp", "tmp", "tmp", "tmp"),
                          kjonn=c("tmp", "tmp"), #?
                          hastegrad2=c("tmp", "tmp", "tmp", "tmp", "tmp"),
                          prosent=F,
                          forenkling=F,
                          keepNames=F,
                          snitt=T,
                          hdg="Alle",
                          icd10="Alle")
  
  verdier <- originalverdier
  hjelpetekst <- lagHjelpetekst(
    tab =             verdier$fane,
    rad =             verdier$rad,
    kol =             verdier$kol,
    verdi =           verdier$verdi,
    aar =             verdier$aar,
    bo =              verdier$bo,
    beh =             verdier$beh,
    prosent =         verdier$prosent,
    behandlingsniva = verdier$behandlingsniva,
    alder =           verdier$alder,
    kjonn =           verdier$kjonn,
    hastegrad2 =      verdier$hastegrad2,
    forenkling =      verdier$forenkling)
  expect_equal_to_reference(hjelpetekst, "data/ref_tekst1.rds")
  
  verdier$aar <- c(2011,2013,2014,2015)
  verdier$fane <- "menisk"
  verdier$prosent <- T
  verdier$forenkling <- T
  verdier$keepNames <- T
  verdier$snitt <- F
  hjelpetekst <- lagHjelpetekst(
    tab =             verdier$fane,
    rad =              c("aar","behandlende_rhf","alder"),
    kol =             "hastegrad_drgtype_dogn",
    verdi =           verdier$verdi,
    aar =             verdier$aar,
    bo =              verdier$bo,
    beh =             verdier$beh,
    prosent =         verdier$prosent,
    behandlingsniva = verdier$behandlingsniva,
    alder =           verdier$alder,
    kjonn =           verdier$kjonn,
    hastegrad2 =      verdier$hastegrad2,
    forenkling =      verdier$forenkling)
  expect_equal_to_reference(hjelpetekst, "data/ref_tekst2.rds")
  
  verdier <- originalverdier
  verdier$fane <- "random"
  for (bohf in c(1,2,3,4,5,6)){
    hjelpetekst <- lagHjelpetekst(
      tab =             verdier$fane,
      rad =             c("boomr_sykehus","behandlende_sykehus"),
      kol =             "hastegrad",
      verdi =           verdier$verdi,
      aar =             c("2014", "2015", "2016"),
      bo =              bohf,
      beh =             verdier$beh,
      prosent =         verdier$prosent,
      behandlingsniva = verdier$behandlingsniva,
      alder =           verdier$alder,
      kjonn =           verdier$kjonn,
      hastegrad2 =      verdier$hastegrad2,
      forenkling =      verdier$forenkling)
    expect_equal_to_reference(hjelpetekst, paste0("data/ref_tekst_bo",  bohf, ".rds"))
  }
  
  for (behhf in c(1,2,3,4,5,6,7)){
    hjelpetekst <- lagHjelpetekst(
      tab =             verdier$fane,
      rad =             c("boomr_rhf","aar"),
      kol =             "behandlingsniva",
      verdi =           verdier$verdi,
      aar =             "2015",
      bo =              verdier$bo,
      beh =             behhf,
      prosent =         T,
      behandlingsniva = c("dag"),
      alder =           c("1", "2", "3"),
      kjonn =           "mann",
      hastegrad2 =      "Akutt",
      forenkling =      verdier$forenkling)
    expect_equal_to_reference(hjelpetekst, paste0("data/ref_tekst_beh",  behhf, ".rds"))
  }
  
  for (verdi in c("rate", "liggetid", "liggedognindex", "liggedognrate", "drg_poeng", "drgrate", "drg_index", "random")){
    hjelpetekst <- lagHjelpetekst(
      tab =             verdier$fane,
      rad =             c("behandler","hastegrad"),
      kol =             "kjonn",
      verdi =           verdi,
      aar =             c("2011", "2013", "2014", "2015"),
      bo =              verdier$bo,
      beh =             verdier$beh,
      prosent =         verdier$prosent,
      behandlingsniva = c("dag", "dogn"),
      alder =           "0-16",
      kjonn =           verdier$kjonn,
      hastegrad2 =      c("en", "to", "tre"),
      forenkling =      T)
    expect_equal_to_reference(hjelpetekst, paste0("data/ref_tekst_verdi_",  verdi, ".rds"))
  }
  
  
  for (tab in c("dogn","dag","poli","Informasjon")){
    hjelpetekst <- lagHjelpetekst(
      tab =             tab,
      rad =             c("episodefag","fag_skde","drgtypehastegrad"),
      kol =             "boomr_rhf",
      verdi =           verdier$verdi,
      aar =             verdier$aar,
      bo =              1,
      beh =             verdier$beh,
      prosent =         verdier$prosent,
      behandlingsniva = verdier$behandlingsniva,
      alder =           verdier$alder,
      kjonn =           verdier$kjonn,
      hastegrad2 =      verdier$hastegrad2,
      forenkling =      verdier$forenkling)
    expect_equal_to_reference(hjelpetekst, paste0("data/ref_tekst_tab_",  tab, ".rds"))
  }
})
