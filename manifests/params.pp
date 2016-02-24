# This private class provides the module's params.
#
class dariahshibboleth::params {

  # define the DARIAH-DE IdP
  $idp_entityid                = 'https://ldap-dariah.esc.rzg.mpg.de/idp/shibboleth'
  $federation_registration_url = 'https://auth.dariah.eu/Shibboleth.sso/Login?target=/cgi-bin/selfservice/ldapportal.pl%3Fmode%3Dauthenticate%3Bshibboleth%3D1%3Bnextpage%3Dregistration%3Breturnurl%3D'

  # default to using metadata from DFN Basic federation but no federation setup
  $dfn_metadata       = 'Basic'
  $federation_enabled = false
  $edugain_enabled    = false
  $mail_contact       = 'root@localhost'

  #default REMOTE_USER preference list
  $remote_user_pref_list = 'eppn persistent-id targeted-id'

  # metadata, values looked up from hiera
  $shibd_metadata_hash = hiera_hash('dariahshibboleth::MetaData',{no => 'data'})

  $shibd_metadata = {#
    'md_dn_de'   => pick($shibd_metadata_hash['UIInfo_DisplayName_de'],$shibd_metadata_hash['UIInfo_DisplayName_en'],'DARIAH'),
    'md_dn_en'   => pick($shibd_metadata_hash['UIInfo_DisplayName_en'],$shibd_metadata_hash['UIInfo_DisplayName_de'],'DARIAH'),
    'md_des_de'  => pick($shibd_metadata_hash['UIInfo_Description_de'],$shibd_metadata_hash['UIInfo_Description_en'],'DARIAH'),
    'md_des_en'  => pick($shibd_metadata_hash['UIInfo_Description_en'],$shibd_metadata_hash['UIInfo_Description_de'],'DARIAH'),
    'md_logo_sm' => pick($shibd_metadata_hash['UIInfo_Logo_small'],'https://res.de.dariah.eu/aai/img/DARIAH_flower_icon.png'),
    'md_logo_bi' => pick($shibd_metadata_hash['UIInfo_Logo_big'],'https://res.de.dariah.eu/aai/img/DARIAH_flower.png'),
    'md_iu_de'   => pick($shibd_metadata_hash['UIInfo_InformationURL_de'],$shibd_metadata_hash['UIInfo_InformationURL_en'],'http://www.dariah.eu'),
    'md_iu_en'   => pick($shibd_metadata_hash['UIInfo_InformationURL_en'],$shibd_metadata_hash['UIInfo_InformationURL_de'],'http://www.dariah.eu'),
    'md_t_gn'    => pick($shibd_metadata_hash['ContactPerson_technical_GivenName'],$shibd_metadata_hash['ContactPerson_support_GivenName'],'DARIAH Support'),
    'md_t_em'    => pick($shibd_metadata_hash['ContactPerson_technical_EmailAddress'],$shibd_metadata_hash['ContactPerson_support_EmailAddress'],'root@localhost'),
    'md_s_gn'    => pick($shibd_metadata_hash['ContactPerson_support_GivenName'],$shibd_metadata_hash['ContactPerson_technical_GivenName'],'DARIAH Support'),
    'md_s_em'    => pick($shibd_metadata_hash['ContactPerson_support_EmailAddress'],$shibd_metadata_hash['ContactPerson_technical_EmailAddress'],'root@localhost'),
    'ACS_Hosts'  => pick($shibd_metadata_hash['ACS_Hosts'],[]),
  }

  # create fake shibboleth credentials for use in Apache, values optionally provided by hiera
  $shibd_fakecredentials_hash = hiera_hash('dariahshibboleth::FakeCredentials',{no => 'data'})

  $_shibd_first      = pick($shibd_fakecredentials_hash['firstname'],'Jane')
  $_shibd_last       = pick($shibd_fakecredentials_hash['lastname'],'Doe')
  $_shibd_mail       = pick($shibd_fakecredentials_hash['mail'],'jane.doe@example.com')
  $_shibd_eppn       = pick($shibd_fakecredentials_hash['eppn'],'JaneDoe@dariah.eu')
  $_shibd_isMemberOf = pick($shibd_fakecredentials_hash['isMemberOf'],'group1;group2')

  $fakeshibdata = "
    SetEnv cn \"${_shibd_first} ${_shibd_last}\"
    SetEnv eppn \"${_shibd_eppn}\"
    SetEnv givenName \"${_shibd_first}\"
    SetEnv mail \"${_shibd_mail}\"
    SetEnv isMemberOf \"${_shibd_isMemberOf}\"
    SetEnv sn \"${_shibd_last}\"
    SetEnv REMOTE_USER \"${_shibd_eppn}\"
    SetEnv Shib-Session-Index \"_11223344556677889900aabbccddeeff\"
    SetEnv Shib-Session-ID \"_11223344556677889900aabbccddeeff\"
  "

}


