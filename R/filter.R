#' Filter out data from dataset
#'
#' Filter out data from the dataset that is not going to be tabulated
#'
#' @param tabell The dataset that is going to be filtred.
#' @param fane The active tab (effect if "dogn", "dag" or "poli")
#' @param verdi The value that is going to be tabulated (only an effect if "liggedognindex" or "drg_index")
#' @param aar The years to be tabulated
#' @param bo Possible values 1:6
#' @param beh  Possible values 1:7
#' @param behandlingsniva Type of contact (admissions, outpatient consultations or day patient treatments)
#' @param alder Age group
#' @param kjonn Gender
#' @param hastegrad2 Degree of urgency
#' @param hdg  Main diagnostic group
#' @param icd10 ICD10 chapter
#' @param fag Medical fields
#'
filtrerUt <- function(tabell, fane, verdi,
                      aar, bo, beh, behandlingsniva, alder, kjonn, hastegrad1, hastegrad2, hdg, icd10, fag){

  if (fane == "dogn"){
    tabell <- filterBehandlingsniva(tabell, c("Døgnopphold"))
  }
  else if (fane == "dag"){
    tabell <- filterBehandlingsniva(tabell, c("Dagbehandling"))
  }
  else if (fane == "poli"){
    tabell <- filterBehandlingsniva(tabell, c("Poliklinikk"))
  }

  tabell <- filterHDG(tabell, hdg)

  tabell <- filterICD10(tabell, icd10)

  tabell <- filterFag(tabell, fag)

  tabell <- filterAar(tabell, aar)

  if (verdi == "liggedognindex"){
    tabell <- filterBehandlingsniva(tabell, c("Døgnopphold"))
  }

  if (verdi == "drg_index"){# ta ut avtalespesialistene
    tabell <- filterBehandlingsniva(tabell, c("Døgnopphold","Dagbehandling","Poliklinikk"))
  }

  tabell <- filterBo(tabell,bo)

  tabell <- filterBeh(tabell,beh)

  tabell <- filterBehandlingsniva(tabell, behandlingsniva)

  tabell <- filterAlder(tabell,alder)

  tabell <- filterKjonn(tabell,kjonn)

  tabell <- filterHastegrad1(tabell, hastegrad1)

  tabell <- filterHastegrad2(tabell, hastegrad2)

  return(tabell)
}


# Kun se på boområdet man er interessert i
filterBo <- function(datasett, bo){
  if (bo == 1){
    return(datasett)
  }
  else if (bo == 2){
    tmpsett <- dplyr::filter(datasett, boomr_rhf == "Boomr Helse Nord RHF")
    return(tmpsett)
  }
  else if (bo == 3){
    tmpsett <- dplyr::filter(datasett, boomr_hf == "Finnmark")
    return(tmpsett)
  }
  else if (bo == 4){
    tmpsett <- dplyr::filter(datasett, boomr_hf == "UNN")
    return(tmpsett)
  }
  else if (bo == 5){
    tmpsett <- dplyr::filter(datasett, boomr_hf == "Nordland")
    return(tmpsett)
  }
  else if (bo == 6){
    tmpsett <- dplyr::filter(datasett, boomr_hf == "Helgeland")
    return(tmpsett)
  }
}

# Kun se på behandlende foretak man er interessert i
filterBeh <- function(datasett, beh){
  if (beh == 1){
    # ingen filtrering
    return(datasett)
  }
  # Gammel kode. For filtrering av Behandler
  #  else if(FALSE){
  #    if (beh == 2){
  #      tmpsett <- dplyr::filter(datasett, Behandler %in% c("Eget lokalsykehus","UNN Tromsø","NLSH Bodø","Annet sykehus i eget HF","Annet HF i HN"))
  #      return(tmpsett)
  #    }
  #    if (beh == 3){
  #      tmpsett <- dplyr::filter(datasett, Behandler == "Eget lokalsykehus")
  #      return(tmpsett)
  #    }
  #    if (beh == 4){
  #      tmpsett <- dplyr::filter(datasett, Behandler == "UNN Tromsø")
  #      return(tmpsett)
  #    }
  #    if (beh == 5){
  #      tmpsett <- dplyr::filter(datasett, Behandler == "NLSH Bodø")
  #      return(tmpsett)
  #    }
  #    if (beh == 6){
  #      tmpsett <- dplyr::filter(datasett, Behandler == "Annet sykehus i eget HF")
  #      return(tmpsett)
  #    }
  #    if (beh == 7){
  #      tmpsett <- dplyr::filter(datasett, Behandler == "Annet HF i HN")
  #      return(tmpsett)
  #    }
  #    if (beh == 8){
  #      tmpsett <- dplyr::filter(datasett, Behandler == "HF i andre RHF")
  #      return(tmpsett)
  #    }
  #  }
  else {
    if (beh == 2){
      tmpsett <- dplyr::filter(datasett, behandlende_rhf == "Helse Nord RHF")
      return(tmpsett)
    }
    else if (beh == 3){
      tmpsett <- dplyr::filter(datasett, behandlende_hf_hn == "Finnmarkssykehuset HF")
      return(tmpsett)
    }
    else if (beh == 4){
      tmpsett <- dplyr::filter(datasett, behandlende_hf_hn == "UNN HF")
      return(tmpsett)
    }
    else if (beh == 5){
      tmpsett <- dplyr::filter(datasett, behandlende_hf_hn == "Nordlandssykehuset HF")
      return(tmpsett)
    }
    else if (beh == 6){
      tmpsett <- dplyr::filter(datasett, behandlende_hf_hn == "Helgelandssykehuset HF")
      return(tmpsett)
    }
    else if (beh == 7){
      tmpsett <- dplyr::filter(datasett, behandlende_hf_hn == "HF utenfor Helse Nord RHF")
      return(tmpsett)
    }
    else if (beh == 8){
      tmpsett <- dplyr::filter(datasett, behandlende_hf_hn == "Avtalespesialister")
      return(tmpsett)
    }
    else if (beh == 9){
      tmpsett <- dplyr::filter(datasett, behandlende_hf_hn == "Private sykehus")
      return(tmpsett)
    }
  }
}

# Disse filter-rutinene burde legges sammen til en rutine
filterAar <- function(datasett, filter){
  tabell <- dplyr::filter(datasett, aar %in% as.numeric(filter))
  return(tabell)
}


filterBehandlingsniva <- function(datasett, filter){
  if (!("behandlingsniva" %in% colnames(datasett))){
    return(datasett)
  }

  tabell <- dplyr::filter(datasett, behandlingsniva %in% filter)
  return(tabell)
}

filterHastegrad1 <- function(datasett, filter){
  if (!("hastegrad" %in% colnames(datasett))){
    return(datasett)
  }
  tabell <- dplyr::filter(datasett, hastegrad %in% filter)
  return(tabell)
}

filterHastegrad2 <- function(datasett, filter){
  if (!("drgtypehastegrad" %in% colnames(datasett))){
    return(datasett)
  }

  tabell <- dplyr::filter(datasett, drgtypehastegrad %in% filter)
  return(tabell)
}

filterAlder <- function(datasett, filter){
  if (!("alder" %in% colnames(datasett))){
    return(datasett)
  }
  if (length(filter) == 4){
    return(datasett)
  } else {
    tabell <- dplyr::filter(datasett, alder %in% filter)
    return(tabell)
  }
}

filterKjonn <- function(datasett, filter){
  if (!("kjonn" %in% colnames(datasett))){
    return(datasett)
  }
  tabell <- dplyr::filter(datasett, kjonn %in% filter)
  return(tabell)
}

filterHDG <- function(datasett, filter){
  if (filter == "Alle"){
    return(datasett)
  } else {
    tabell <- dplyr::filter(datasett, hoveddiagnosegruppe %in% filter)
  }
}

filterICD10 <- function(datasett, filter){
  if (filter == "Alle"){
    return(datasett)
  } else {
    tabell <- dplyr::filter(datasett, icd10kap %in% filter)
  }
}

filterFag <- function(datasett, filter){
  if (filter == "Alle"){
    return(datasett)
  } else {
    tabell <- dplyr::filter(datasett, episodefag %in% filter)
  }
}
