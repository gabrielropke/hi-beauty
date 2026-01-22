import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pt')];

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @createAccountAgreement.
  ///
  /// In pt, this message translates to:
  /// **'Ao criar uma conta você concorda com os'**
  String get createAccountAgreement;

  /// No description provided for @termsOfUse.
  ///
  /// In pt, this message translates to:
  /// **'Termos de Uso'**
  String get termsOfUse;

  /// No description provided for @and.
  ///
  /// In pt, this message translates to:
  /// **'e'**
  String get and;

  /// No description provided for @hi.
  ///
  /// In pt, this message translates to:
  /// **'Olá'**
  String get hi;

  /// No description provided for @privacyPolicy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get privacyPolicy;

  /// No description provided for @moveAndResize.
  ///
  /// In pt, this message translates to:
  /// **'Mover e redimensionar'**
  String get moveAndResize;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @next.
  ///
  /// In pt, this message translates to:
  /// **'Próximo'**
  String get next;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @select.
  ///
  /// In pt, this message translates to:
  /// **'Selecione'**
  String get select;

  /// No description provided for @continueLabel.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continueLabel;

  /// No description provided for @or.
  ///
  /// In pt, this message translates to:
  /// **'Ou'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar com Google'**
  String get continueWithGoogle;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome completo'**
  String get name;

  /// No description provided for @whatsapp.
  ///
  /// In pt, this message translates to:
  /// **'Whatsapp'**
  String get whatsapp;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @whatsappHint.
  ///
  /// In pt, this message translates to:
  /// **'(11) 99999-9999'**
  String get whatsappHint;

  /// No description provided for @typeHere.
  ///
  /// In pt, this message translates to:
  /// **'Digite aqui...'**
  String get typeHere;

  /// No description provided for @nameHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite seu nome completo'**
  String get nameHint;

  /// No description provided for @emailHint.
  ///
  /// In pt, this message translates to:
  /// **'Insira seu endereço de e-mail'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua senha'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci minha senha'**
  String get forgotPassword;

  /// No description provided for @entry.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get entry;

  /// No description provided for @dontHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Não tem uma conta?'**
  String get dontHaveAccount;

  /// No description provided for @clickHere.
  ///
  /// In pt, this message translates to:
  /// **'Clique aqui'**
  String get clickHere;

  /// No description provided for @registerToAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar uma conta'**
  String get registerToAccount;

  /// No description provided for @createAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get createAccount;

  /// No description provided for @registerToAccountDescription.
  ///
  /// In pt, this message translates to:
  /// **'Crie uma conta com seu e-mail ou sua conta Google e experimente a plataforma gratuitamente.'**
  String get registerToAccountDescription;

  /// No description provided for @loginToAccount.
  ///
  /// In pt, this message translates to:
  /// **'Acesse sua conta'**
  String get loginToAccount;

  /// No description provided for @min6Chars.
  ///
  /// In pt, this message translates to:
  /// **'Mínimo de 6 caracteres'**
  String get min6Chars;

  /// No description provided for @oneUppercase.
  ///
  /// In pt, this message translates to:
  /// **'1 letra maiúscula'**
  String get oneUppercase;

  /// No description provided for @oneLowercase.
  ///
  /// In pt, this message translates to:
  /// **'1 letra minúscula'**
  String get oneLowercase;

  /// No description provided for @oneSpecialChar.
  ///
  /// In pt, this message translates to:
  /// **'1 caracter especial'**
  String get oneSpecialChar;

  /// No description provided for @verifyEmail.
  ///
  /// In pt, this message translates to:
  /// **'Verifique seu e-mail'**
  String get verifyEmail;

  /// No description provided for @invalidCode.
  ///
  /// In pt, this message translates to:
  /// **'Código inválido'**
  String get invalidCode;

  /// No description provided for @resendCodeTimer.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar código em {segundos} segundo'**
  String resendCodeTimer(Object segundos);

  /// No description provided for @resendCode.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar código'**
  String get resendCode;

  /// No description provided for @verifyEmailDescription.
  ///
  /// In pt, this message translates to:
  /// **'Enviamos um e-mail para {email} com o código de confirmação. Acesse sua caixa para conferir o código e insira abaixo:'**
  String verifyEmailDescription(Object email);

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @incorrectUser.
  ///
  /// In pt, this message translates to:
  /// **'E-mail ou senha inválidos.'**
  String get incorrectUser;

  /// No description provided for @howGetHere.
  ///
  /// In pt, this message translates to:
  /// **'Como nos encontrou?'**
  String get howGetHere;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Esqueceu a senha?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In pt, this message translates to:
  /// **'Se você já tem uma conta cadastrada com o e-mail informado, você receberá uma mensagem na sua caixa de entrada para redefinir sua senha. Caso não receba, verifique a caixa de spam'**
  String get forgotPasswordDescription;

  /// No description provided for @resetPassword.
  ///
  /// In pt, this message translates to:
  /// **'Redefinir senha'**
  String get resetPassword;

  /// No description provided for @forgotEmailInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Este e-mail não está registrado'**
  String get forgotEmailInvalid;

  /// No description provided for @yourBusiness.
  ///
  /// In pt, this message translates to:
  /// **'Seu negócio'**
  String get yourBusiness;

  /// No description provided for @yourBusinessDescription.
  ///
  /// In pt, this message translates to:
  /// **'Preencha os dados abaixo para registrar seu negócio e começar a suar gratuitamente.'**
  String get yourBusinessDescription;

  /// No description provided for @yourBusinessName.
  ///
  /// In pt, this message translates to:
  /// **'Nome do negócio'**
  String get yourBusinessName;

  /// No description provided for @yourBusinessNametitle.
  ///
  /// In pt, this message translates to:
  /// **'Qual é o nome do seu\nnegócio?'**
  String get yourBusinessNametitle;

  /// No description provided for @yourBusinessNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Negócio da Maria'**
  String get yourBusinessNameHint;

  /// No description provided for @slugHint.
  ///
  /// In pt, this message translates to:
  /// **'negocio-da-maria'**
  String get slugHint;

  /// No description provided for @slugDescription.
  ///
  /// In pt, this message translates to:
  /// **'Seus clientes acessarão: hibeauty.co/seu-link'**
  String get slugDescription;

  /// No description provided for @moreSelection.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma ou mais'**
  String get moreSelection;

  /// No description provided for @createYourLink.
  ///
  /// In pt, this message translates to:
  /// **'Crie seu link'**
  String get createYourLink;

  /// No description provided for @segmentBusiness.
  ///
  /// In pt, this message translates to:
  /// **'Segmento de atuação'**
  String get segmentBusiness;

  /// No description provided for @segmentBusinessDescription.
  ///
  /// In pt, this message translates to:
  /// **'Selecione a categoria que melhor descreve o seu negócio. Isso nos ajudará a criar uma melhor experiência para você!'**
  String get segmentBusinessDescription;

  /// No description provided for @subSegments.
  ///
  /// In pt, this message translates to:
  /// **'Especialidades'**
  String get subSegments;

  /// No description provided for @subSegmentBusiness.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma ou mais especialidades do seu negócio'**
  String get subSegmentBusiness;

  /// No description provided for @yourBusinessSizeTeam.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho da equipe'**
  String get yourBusinessSizeTeam;

  /// No description provided for @onlyLowercaseAndNumbers.
  ///
  /// In pt, this message translates to:
  /// **'Somente letras minúsculas e números'**
  String get onlyLowercaseAndNumbers;

  /// No description provided for @yourBusinessIndustryHint.
  ///
  /// In pt, this message translates to:
  /// **'Seleciona a opção que melhor descreva a sua atividade'**
  String get yourBusinessIndustryHint;

  /// No description provided for @informationEditedInTheFuture.
  ///
  /// In pt, this message translates to:
  /// **'Estas informações podem ser editadas a qualquer momento no menu de configurações'**
  String get informationEditedInTheFuture;

  /// No description provided for @configAccount.
  ///
  /// In pt, this message translates to:
  /// **'Configurações da conta'**
  String get configAccount;

  /// No description provided for @initial.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get initial;

  /// No description provided for @business.
  ///
  /// In pt, this message translates to:
  /// **'Negócio'**
  String get business;

  /// No description provided for @notifications.
  ///
  /// In pt, this message translates to:
  /// **'Notificações'**
  String get notifications;

  /// No description provided for @site.
  ///
  /// In pt, this message translates to:
  /// **'Site'**
  String get site;

  /// No description provided for @gallery.
  ///
  /// In pt, this message translates to:
  /// **'Galeria'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In pt, this message translates to:
  /// **'Câmera'**
  String get camera;

  /// No description provided for @appointments.
  ///
  /// In pt, this message translates to:
  /// **'Agendamentos'**
  String get appointments;

  /// No description provided for @myAppointments.
  ///
  /// In pt, this message translates to:
  /// **'Meus agendamentos'**
  String get myAppointments;

  /// No description provided for @myProfile.
  ///
  /// In pt, this message translates to:
  /// **'Meu perfil'**
  String get myProfile;

  /// No description provided for @clients.
  ///
  /// In pt, this message translates to:
  /// **'Clientes'**
  String get clients;

  /// No description provided for @myBusiness.
  ///
  /// In pt, this message translates to:
  /// **'Meu negócio'**
  String get myBusiness;

  /// No description provided for @myBusinessDescription.
  ///
  /// In pt, this message translates to:
  /// **'Gerencie as informações do seu negócio e mantenha seus dados sempre atualizados, essas informações estarão disponíveis no seu site'**
  String get myBusinessDescription;

  /// No description provided for @your.
  ///
  /// In pt, this message translates to:
  /// **'Clientes'**
  String get your;

  /// No description provided for @yourBusinessSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Fale sobre seu negócio'**
  String get yourBusinessSubtitle;

  /// No description provided for @address.
  ///
  /// In pt, this message translates to:
  /// **'Endereço'**
  String get address;

  /// No description provided for @addressEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar seu local'**
  String get addressEdit;

  /// No description provided for @businessAddress.
  ///
  /// In pt, this message translates to:
  /// **'Onde está localizada o seu negócio?'**
  String get businessAddress;

  /// No description provided for @insertToContinue.
  ///
  /// In pt, this message translates to:
  /// **'Preenche o campo acima para continuar o cadastro'**
  String get insertToContinue;

  /// No description provided for @district.
  ///
  /// In pt, this message translates to:
  /// **'Bairro'**
  String get district;

  /// No description provided for @city.
  ///
  /// In pt, this message translates to:
  /// **'Cidade'**
  String get city;

  /// No description provided for @state.
  ///
  /// In pt, this message translates to:
  /// **'Estado'**
  String get state;

  /// No description provided for @contact.
  ///
  /// In pt, this message translates to:
  /// **'Contato'**
  String get contact;

  /// No description provided for @zipcode.
  ///
  /// In pt, this message translates to:
  /// **'CEP'**
  String get zipcode;

  /// No description provided for @number.
  ///
  /// In pt, this message translates to:
  /// **'Número'**
  String get number;

  /// No description provided for @complement.
  ///
  /// In pt, this message translates to:
  /// **'Complemento'**
  String get complement;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Senha alterada com sucesso!'**
  String get resetPasswordSuccess;

  /// No description provided for @messageSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Alterações salvas com sucesso!'**
  String get messageSuccess;

  /// No description provided for @insertImageHint.
  ///
  /// In pt, this message translates to:
  /// **'Clique para inserir uma logo para a seu negócio'**
  String get insertImageHint;

  /// No description provided for @personalData.
  ///
  /// In pt, this message translates to:
  /// **'Informações pessoais'**
  String get personalData;

  /// No description provided for @businessData.
  ///
  /// In pt, this message translates to:
  /// **'Informações do negócio'**
  String get businessData;

  /// No description provided for @dataNull.
  ///
  /// In pt, this message translates to:
  /// **'Complete seu cadastro'**
  String get dataNull;

  /// No description provided for @dataNullDescription.
  ///
  /// In pt, this message translates to:
  /// **'Complete seu cadastro preenchendo as informações solicitadas abaixo'**
  String get dataNullDescription;

  /// No description provided for @businessDataDescription.
  ///
  /// In pt, this message translates to:
  /// **'Preencha os dados abaixo para criar sua conta.'**
  String get businessDataDescription;

  /// No description provided for @descriptionBusiness.
  ///
  /// In pt, this message translates to:
  /// **'Sobre o negócio'**
  String get descriptionBusiness;

  /// No description provided for @customizeIdentify.
  ///
  /// In pt, this message translates to:
  /// **'Customize sua identidade'**
  String get customizeIdentify;

  /// No description provided for @insertImageAndCoverImage.
  ///
  /// In pt, this message translates to:
  /// **'Insira as imagens da sua marca'**
  String get insertImageAndCoverImage;

  /// No description provided for @optional.
  ///
  /// In pt, this message translates to:
  /// **'Opcional'**
  String get optional;

  /// No description provided for @favoriteColor.
  ///
  /// In pt, this message translates to:
  /// **'Qual é a cor do seu negócio?'**
  String get favoriteColor;

  /// No description provided for @favoriteColorDescription.
  ///
  /// In pt, this message translates to:
  /// **'A cor escolhida será utilizando na sua marca e vista pelos seus clientes'**
  String get favoriteColorDescription;

  /// No description provided for @logo.
  ///
  /// In pt, this message translates to:
  /// **'Logo'**
  String get logo;

  /// No description provided for @background.
  ///
  /// In pt, this message translates to:
  /// **'Capa do seu negócio'**
  String get background;

  /// No description provided for @instagram.
  ///
  /// In pt, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @instagramHint.
  ///
  /// In pt, this message translates to:
  /// **'seu_instagram'**
  String get instagramHint;

  /// No description provided for @todayIs.
  ///
  /// In pt, this message translates to:
  /// **'Hoje é'**
  String get todayIs;

  /// No description provided for @customer.
  ///
  /// In pt, this message translates to:
  /// **'Cliente'**
  String get customer;

  /// No description provided for @customersList.
  ///
  /// In pt, this message translates to:
  /// **'Lista de clientes'**
  String get customersList;

  /// No description provided for @searchCurstomersHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome, e-mail ou telefone...'**
  String get searchCurstomersHint;

  /// No description provided for @customersListDescription.
  ///
  /// In pt, this message translates to:
  /// **'Gerencie os clientes do seu negócio.'**
  String get customersListDescription;

  /// No description provided for @add.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get add;

  /// No description provided for @filters.
  ///
  /// In pt, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// No description provided for @moreRecent.
  ///
  /// In pt, this message translates to:
  /// **'Mais recentes'**
  String get moreRecent;

  /// No description provided for @moreOld.
  ///
  /// In pt, this message translates to:
  /// **'Mais antigos'**
  String get moreOld;

  /// No description provided for @you.
  ///
  /// In pt, this message translates to:
  /// **'Você'**
  String get you;

  /// No description provided for @customerExemplo.
  ///
  /// In pt, this message translates to:
  /// **'Cliente exemplo'**
  String get customerExemplo;

  /// No description provided for @completeSetup.
  ///
  /// In pt, this message translates to:
  /// **'Finalize o cadastro do seu negócio'**
  String get completeSetup;

  /// No description provided for @businessCardOptionData.
  ///
  /// In pt, this message translates to:
  /// **'Dados cadastrais'**
  String get businessCardOptionData;

  /// No description provided for @businessCardOptionTeam.
  ///
  /// In pt, this message translates to:
  /// **'Equipe'**
  String get businessCardOptionTeam;

  /// No description provided for @businessCardOptionReviews.
  ///
  /// In pt, this message translates to:
  /// **'Avaliações'**
  String get businessCardOptionReviews;

  /// No description provided for @businessCardOptionClients.
  ///
  /// In pt, this message translates to:
  /// **'Clientes'**
  String get businessCardOptionClients;

  /// No description provided for @businessCardOptionServices.
  ///
  /// In pt, this message translates to:
  /// **'Catálogo'**
  String get businessCardOptionServices;

  /// No description provided for @businessCardOptionMyTeam.
  ///
  /// In pt, this message translates to:
  /// **'Minha equipe'**
  String get businessCardOptionMyTeam;

  /// No description provided for @mySite.
  ///
  /// In pt, this message translates to:
  /// **'Meu site'**
  String get mySite;

  /// No description provided for @customize.
  ///
  /// In pt, this message translates to:
  /// **'Customização'**
  String get customize;

  /// No description provided for @visual.
  ///
  /// In pt, this message translates to:
  /// **'Visual'**
  String get visual;

  /// No description provided for @brandColor.
  ///
  /// In pt, this message translates to:
  /// **'Cor da marca'**
  String get brandColor;

  /// No description provided for @previewColor.
  ///
  /// In pt, this message translates to:
  /// **'Preview da cor'**
  String get previewColor;

  /// No description provided for @principalColor.
  ///
  /// In pt, this message translates to:
  /// **'Cor principal'**
  String get principalColor;

  /// No description provided for @brandImage.
  ///
  /// In pt, this message translates to:
  /// **'Logo do negócio'**
  String get brandImage;

  /// No description provided for @brandCoverImage.
  ///
  /// In pt, this message translates to:
  /// **'Capa do site'**
  String get brandCoverImage;

  /// No description provided for @brandImageReccomendation.
  ///
  /// In pt, this message translates to:
  /// **'Recomendado: 400x400px, PNG/JPG'**
  String get brandImageReccomendation;

  /// No description provided for @brandCoverImageReccomendatio.
  ///
  /// In pt, this message translates to:
  /// **'Recomendado: 1200x400px, PNG/JPG'**
  String get brandCoverImageReccomendatio;

  /// No description provided for @customizeDescription.
  ///
  /// In pt, this message translates to:
  /// **'Personalize a aparência do seu site'**
  String get customizeDescription;

  /// No description provided for @businessDataSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Informações essenciais do seu negócio'**
  String get businessDataSubtitle;

  /// No description provided for @customizeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Personalização visual do seu site'**
  String get customizeSubtitle;

  /// No description provided for @whatsappSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Conectar para comunicação com clientes'**
  String get whatsappSubtitle;

  /// No description provided for @addressSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Localização do seu estabelecimento'**
  String get addressSubtitle;

  /// No description provided for @progress.
  ///
  /// In pt, this message translates to:
  /// **'Progresso'**
  String get progress;

  /// No description provided for @connect.
  ///
  /// In pt, this message translates to:
  /// **'Conectar'**
  String get connect;

  /// No description provided for @discconnect.
  ///
  /// In pt, this message translates to:
  /// **'Desconectar'**
  String get discconnect;

  /// No description provided for @principal.
  ///
  /// In pt, this message translates to:
  /// **'Principal'**
  String get principal;

  /// No description provided for @inDevelopment.
  ///
  /// In pt, this message translates to:
  /// **'Em breve'**
  String get inDevelopment;

  /// No description provided for @businessSectionConfig.
  ///
  /// In pt, this message translates to:
  /// **'Configuração do Negócio'**
  String get businessSectionConfig;

  /// No description provided for @businessSectionConfigDescription.
  ///
  /// In pt, this message translates to:
  /// **'Complete as 4 etapas para ativar todas as funcionalidades'**
  String get businessSectionConfigDescription;

  /// No description provided for @businessConfig.
  ///
  /// In pt, this message translates to:
  /// **'Configurações do ambiente de trabalho'**
  String get businessConfig;

  /// No description provided for @businessConfigDescription.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar configurações para'**
  String get businessConfigDescription;

  /// No description provided for @editBusiness.
  ///
  /// In pt, this message translates to:
  /// **'Editar dados do negócio'**
  String get editBusiness;

  /// No description provided for @editBusinessDescription.
  ///
  /// In pt, this message translates to:
  /// **'Escolha os dados do seu negócio que serão utilizados como perfil da empresa, e exibidos em recibos de vendas ou mensagens.'**
  String get editBusinessDescription;

  /// No description provided for @schedule.
  ///
  /// In pt, this message translates to:
  /// **'Agendar'**
  String get schedule;

  /// No description provided for @time.
  ///
  /// In pt, this message translates to:
  /// **'Horário'**
  String get time;

  /// No description provided for @profile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @themeColor.
  ///
  /// In pt, this message translates to:
  /// **'Cor tema'**
  String get themeColor;

  /// No description provided for @teamMembers.
  ///
  /// In pt, this message translates to:
  /// **'Colaboradores'**
  String get teamMembers;

  /// No description provided for @collaboratorPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Foto do(a) colaborador(a)'**
  String get collaboratorPhoto;

  /// No description provided for @roleAndFunction.
  ///
  /// In pt, this message translates to:
  /// **'Cargo e função'**
  String get roleAndFunction;

  /// No description provided for @roleAndCustomizationSettings.
  ///
  /// In pt, this message translates to:
  /// **'Definições de cargo e personalização'**
  String get roleAndCustomizationSettings;

  /// No description provided for @status.
  ///
  /// In pt, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @lastUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Última atualização'**
  String get lastUpdate;

  /// No description provided for @actions.
  ///
  /// In pt, this message translates to:
  /// **'Ações'**
  String get actions;

  /// No description provided for @searchTeams.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar colaboradores'**
  String get searchTeams;

  /// No description provided for @owner.
  ///
  /// In pt, this message translates to:
  /// **'Proprietário'**
  String get owner;

  /// No description provided for @manager.
  ///
  /// In pt, this message translates to:
  /// **'Gerente'**
  String get manager;

  /// No description provided for @employee.
  ///
  /// In pt, this message translates to:
  /// **'Funcionário'**
  String get employee;

  /// No description provided for @freelancer.
  ///
  /// In pt, this message translates to:
  /// **'Freelancer'**
  String get freelancer;

  /// No description provided for @active.
  ///
  /// In pt, this message translates to:
  /// **'Ativo'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In pt, this message translates to:
  /// **'Inativo'**
  String get inactive;

  /// No description provided for @suspended.
  ///
  /// In pt, this message translates to:
  /// **'Suspenso'**
  String get suspended;

  /// No description provided for @onVacation.
  ///
  /// In pt, this message translates to:
  /// **'Em férias'**
  String get onVacation;

  /// No description provided for @sortBy.
  ///
  /// In pt, this message translates to:
  /// **'Classificar por'**
  String get sortBy;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @apply.
  ///
  /// In pt, this message translates to:
  /// **'Aplicar'**
  String get apply;

  /// No description provided for @profileEditDescription.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar o perfil pessoal dos colaboradores'**
  String get profileEditDescription;

  /// No description provided for @businessHours.
  ///
  /// In pt, this message translates to:
  /// **'Horários de funcionamento'**
  String get businessHours;

  /// No description provided for @businessHoursDescription.
  ///
  /// In pt, this message translates to:
  /// **'Configure os horários do seu negócio e colaboradores'**
  String get businessHoursDescription;

  /// No description provided for @businessSchedule.
  ///
  /// In pt, this message translates to:
  /// **'Horários do Negócio'**
  String get businessSchedule;

  /// No description provided for @addCollaborator.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar colaborador(a)'**
  String get addCollaborator;

  /// No description provided for @scheduledShifts.
  ///
  /// In pt, this message translates to:
  /// **'Turnos programados'**
  String get scheduledShifts;

  /// No description provided for @team.
  ///
  /// In pt, this message translates to:
  /// **'Equipe'**
  String get team;

  /// No description provided for @week.
  ///
  /// In pt, this message translates to:
  /// **'Semana'**
  String get week;

  /// No description provided for @rulesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Regras de Agendamento'**
  String get rulesTitle;

  /// No description provided for @rulesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Configure como seus clientes podem fazer agendamentos'**
  String get rulesSubtitle;

  /// No description provided for @scheduleSettingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configurações de Horário'**
  String get scheduleSettingsTitle;

  /// No description provided for @scheduleSettingsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Defina intervalos e prazos para agendamentos'**
  String get scheduleSettingsSubtitle;

  /// No description provided for @timeIntervalLabel.
  ///
  /// In pt, this message translates to:
  /// **'Intervalo entre horários disponíveis'**
  String get timeIntervalLabel;

  /// No description provided for @timeIntervalOption15min.
  ///
  /// In pt, this message translates to:
  /// **'A cada 15 minutos'**
  String get timeIntervalOption15min;

  /// No description provided for @timeIntervalDescription.
  ///
  /// In pt, this message translates to:
  /// **'Define o espaçamento entre horários disponíveis na agenda'**
  String get timeIntervalDescription;

  /// No description provided for @minAdvanceLabel.
  ///
  /// In pt, this message translates to:
  /// **'Antecedência mínima para agendamento'**
  String get minAdvanceLabel;

  /// No description provided for @minAdvanceHours.
  ///
  /// In pt, this message translates to:
  /// **'horas'**
  String get minAdvanceHours;

  /// No description provided for @minAdvanceDescription.
  ///
  /// In pt, this message translates to:
  /// **'Clientes podem agendar a qualquer momento'**
  String get minAdvanceDescription;

  /// No description provided for @bookingWindowLabel.
  ///
  /// In pt, this message translates to:
  /// **'Janela de agendamento'**
  String get bookingWindowLabel;

  /// No description provided for @bookingWindowDays.
  ///
  /// In pt, this message translates to:
  /// **'dias'**
  String get bookingWindowDays;

  /// No description provided for @bookingWindowDescription.
  ///
  /// In pt, this message translates to:
  /// **'Até quantos dias no futuro os clientes podem agendar'**
  String get bookingWindowDescription;

  /// No description provided for @cancellationSectionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cancelamento e Reagendamento'**
  String get cancellationSectionTitle;

  /// No description provided for @cancellationSectionSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Configure políticas de alteração de agendamentos'**
  String get cancellationSectionSubtitle;

  /// No description provided for @allowRescheduleLabel.
  ///
  /// In pt, this message translates to:
  /// **'Permitir reagendamento'**
  String get allowRescheduleLabel;

  /// No description provided for @allowRescheduleDescription.
  ///
  /// In pt, this message translates to:
  /// **'Clientes podem alterar data e horário dos agendamentos'**
  String get allowRescheduleDescription;

  /// No description provided for @allowCancelLabel.
  ///
  /// In pt, this message translates to:
  /// **'Permitir cancelamento'**
  String get allowCancelLabel;

  /// No description provided for @allowCancelDescription.
  ///
  /// In pt, this message translates to:
  /// **'Clientes podem cancelar agendamentos'**
  String get allowCancelDescription;

  /// No description provided for @minCancelTimeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Prazo mínimo para cancelamento'**
  String get minCancelTimeLabel;

  /// No description provided for @minCancelTimeHours.
  ///
  /// In pt, this message translates to:
  /// **'horas'**
  String get minCancelTimeHours;

  /// No description provided for @minCancelTimeDescription.
  ///
  /// In pt, this message translates to:
  /// **'Cancelamentos devem ser feitos com 0 min de antecedência'**
  String get minCancelTimeDescription;

  /// No description provided for @loginToAccountDescription.
  ///
  /// In pt, this message translates to:
  /// **'Faça login com seu e-mail ou sua conta google'**
  String get loginToAccountDescription;

  /// No description provided for @approvalTitle.
  ///
  /// In pt, this message translates to:
  /// **'Aprovação de Agendamentos'**
  String get approvalTitle;

  /// No description provided for @approvalSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Configure se agendamentos precisam de aprovação manual'**
  String get approvalSubtitle;

  /// No description provided for @requireManualApprovalLabel.
  ///
  /// In pt, this message translates to:
  /// **'Requer aprovação manual'**
  String get requireManualApprovalLabel;

  /// No description provided for @requireManualApprovalDescription.
  ///
  /// In pt, this message translates to:
  /// **'Agendamentos ficam pendentes até serem aprovados'**
  String get requireManualApprovalDescription;

  /// No description provided for @clientLimitsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Limites por Cliente'**
  String get clientLimitsTitle;

  /// No description provided for @clientLimitsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Configure quantos agendamentos cada cliente pode fazer'**
  String get clientLimitsSubtitle;

  /// No description provided for @multiplePerDayLabel.
  ///
  /// In pt, this message translates to:
  /// **'Múltiplos agendamentos por dia'**
  String get multiplePerDayLabel;

  /// No description provided for @multiplePerDayDescription.
  ///
  /// In pt, this message translates to:
  /// **'Permitir mais de um agendamento por cliente no mesmo dia'**
  String get multiplePerDayDescription;

  /// No description provided for @holidayBookingsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Agendamentos em feriados'**
  String get holidayBookingsLabel;

  /// No description provided for @holidayBookingsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Permitir agendamentos em feriados nacionais'**
  String get holidayBookingsDescription;

  /// No description provided for @dailyLimitLabel.
  ///
  /// In pt, this message translates to:
  /// **'Limite diário por cliente (0 = ilimitado)'**
  String get dailyLimitLabel;

  /// No description provided for @currentValueLabel.
  ///
  /// In pt, this message translates to:
  /// **'Atual:'**
  String get currentValueLabel;

  /// No description provided for @unlimitedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Ilimitado'**
  String get unlimitedLabel;

  /// No description provided for @onePerDayLabel.
  ///
  /// In pt, this message translates to:
  /// **'1 por dia'**
  String get onePerDayLabel;

  /// No description provided for @perDaySuffix.
  ///
  /// In pt, this message translates to:
  /// **'por dia'**
  String get perDaySuffix;

  /// No description provided for @termsConditionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Termos e Condições'**
  String get termsConditionsTitle;

  /// No description provided for @termsConditionsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Configure termos que o cliente deve aceitar ao agendar'**
  String get termsConditionsSubtitle;

  /// No description provided for @requireTermsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Exigir aceitação de termos'**
  String get requireTermsLabel;

  /// No description provided for @requireTermsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Cliente deve aceitar termos antes de finalizar agendamento'**
  String get requireTermsDescription;

  /// No description provided for @whatsappNumber.
  ///
  /// In pt, this message translates to:
  /// **'Número do WhatsApp'**
  String get whatsappNumber;

  /// No description provided for @enterNumberToGenerateCode.
  ///
  /// In pt, this message translates to:
  /// **'Digite o número para gerar o código'**
  String get enterNumberToGenerateCode;

  /// No description provided for @aiSettings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações de IA'**
  String get aiSettings;

  /// No description provided for @connectWhatsappToEditPersonality.
  ///
  /// In pt, this message translates to:
  /// **'Conecte o WhatsApp para editar a personalidade'**
  String get connectWhatsappToEditPersonality;

  /// No description provided for @minCancelTimeDynamic.
  ///
  /// In pt, this message translates to:
  /// **'Cancelamentos devem ser feitos com {minutes} min de antecedência'**
  String minCancelTimeDynamic(Object minutes);

  /// No description provided for @tone.
  ///
  /// In pt, this message translates to:
  /// **'Tom'**
  String get tone;

  /// No description provided for @verbosity.
  ///
  /// In pt, this message translates to:
  /// **'Verbosidade'**
  String get verbosity;

  /// No description provided for @whatsappConnected.
  ///
  /// In pt, this message translates to:
  /// **'WhatsApp conectado. Assistente inteligente ativo.'**
  String get whatsappConnected;

  /// No description provided for @personalityStyle.
  ///
  /// In pt, this message translates to:
  /// **'Personalidade & Estilo'**
  String get personalityStyle;

  /// No description provided for @advancedFeatures.
  ///
  /// In pt, this message translates to:
  /// **'Recursos Avançados'**
  String get advancedFeatures;

  /// No description provided for @autoScheduling.
  ///
  /// In pt, this message translates to:
  /// **'Agendamento Automático'**
  String get autoScheduling;

  /// No description provided for @autoSchedulingDesc.
  ///
  /// In pt, this message translates to:
  /// **'Sugere horários livres'**
  String get autoSchedulingDesc;

  /// No description provided for @smartUpsell.
  ///
  /// In pt, this message translates to:
  /// **'Upsell Inteligente'**
  String get smartUpsell;

  /// No description provided for @smartUpsellDesc.
  ///
  /// In pt, this message translates to:
  /// **'Sugestões de serviços extras'**
  String get smartUpsellDesc;

  /// No description provided for @longTexts.
  ///
  /// In pt, this message translates to:
  /// **'Textos Longos'**
  String get longTexts;

  /// No description provided for @longTextsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Interpreta contexto extenso'**
  String get longTextsDesc;

  /// No description provided for @audios.
  ///
  /// In pt, this message translates to:
  /// **'Áudios (PT-BR)'**
  String get audios;

  /// No description provided for @audiosDesc.
  ///
  /// In pt, this message translates to:
  /// **'Transcreve e entende intenção'**
  String get audiosDesc;

  /// No description provided for @smartFollowUp.
  ///
  /// In pt, this message translates to:
  /// **'Follow-up Inteligente'**
  String get smartFollowUp;

  /// No description provided for @smartFollowUpDesc.
  ///
  /// In pt, this message translates to:
  /// **'Perguntas relevantes adicionais'**
  String get smartFollowUpDesc;

  /// No description provided for @multiLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Multi-Idioma'**
  String get multiLanguage;

  /// No description provided for @multiLanguageDesc.
  ///
  /// In pt, this message translates to:
  /// **'Detecta e responde'**
  String get multiLanguageDesc;

  /// No description provided for @audioSupportedNote.
  ///
  /// In pt, this message translates to:
  /// **'Áudio suportado inicialmente em Português (Brasil).'**
  String get audioSupportedNote;

  /// No description provided for @aiPersonalityAdjust.
  ///
  /// In pt, this message translates to:
  /// **'Ajuste como a IA conversa com seus clientes'**
  String get aiPersonalityAdjust;

  /// No description provided for @generatedExample.
  ///
  /// In pt, this message translates to:
  /// **'Exemplo gerado'**
  String get generatedExample;

  /// No description provided for @exampleFriendly1.
  ///
  /// In pt, this message translates to:
  /// **'Opa! Tudo joia? Posso reservar pra você amanhã às 15h, confirmo agora ou prefere outro horário?'**
  String get exampleFriendly1;

  /// No description provided for @exampleProfessional.
  ///
  /// In pt, this message translates to:
  /// **'Olá. Posso proceder com o agendamento amanhã às 15h, confirmo agora ou prefere outro horário?'**
  String get exampleProfessional;

  /// No description provided for @exampleCasual.
  ///
  /// In pt, this message translates to:
  /// **'E aí! Bora marcar isso rapidinho amanhã às 15h, confirmo agora ou prefere outro horário?'**
  String get exampleCasual;

  /// No description provided for @exampleFormal.
  ///
  /// In pt, this message translates to:
  /// **'Prezada(o), posso efetivar o agendamento amanhã às 15h, confirmo agora ou prefere outro horário?'**
  String get exampleFormal;

  /// No description provided for @exampleFunny.
  ///
  /// In pt, this message translates to:
  /// **'E aí, estiloso! Vamos garantir aquele corte top amanhã às 15h, confirmo agora ou prefere outro horário?'**
  String get exampleFunny;

  /// No description provided for @selected.
  ///
  /// In pt, this message translates to:
  /// **'Selecionado'**
  String get selected;

  /// No description provided for @toneFriendly.
  ///
  /// In pt, this message translates to:
  /// **'Amigável'**
  String get toneFriendly;

  /// No description provided for @toneProfessional.
  ///
  /// In pt, this message translates to:
  /// **'Profissional'**
  String get toneProfessional;

  /// No description provided for @toneCasual.
  ///
  /// In pt, this message translates to:
  /// **'Descontraído'**
  String get toneCasual;

  /// No description provided for @toneFormal.
  ///
  /// In pt, this message translates to:
  /// **'Formal'**
  String get toneFormal;

  /// No description provided for @toneFunny.
  ///
  /// In pt, this message translates to:
  /// **'Engraçado'**
  String get toneFunny;

  /// No description provided for @quickToneGuide.
  ///
  /// In pt, this message translates to:
  /// **'Guia rápido de tom'**
  String get quickToneGuide;

  /// No description provided for @toneFriendlyDesc.
  ///
  /// In pt, this message translates to:
  /// **'Acolhedor, aproxima e gera confiança.'**
  String get toneFriendlyDesc;

  /// No description provided for @toneProfessionalDesc.
  ///
  /// In pt, this message translates to:
  /// **'Objetivo, seguro e direto ao ponto.'**
  String get toneProfessionalDesc;

  /// No description provided for @toneCasualDesc.
  ///
  /// In pt, this message translates to:
  /// **'Leve, casual, cria proximidade rapidamente.'**
  String get toneCasualDesc;

  /// No description provided for @toneFormalDesc.
  ///
  /// In pt, this message translates to:
  /// **'Neutro, respeitoso e adequado a todos.'**
  String get toneFormalDesc;

  /// No description provided for @toneFunnyDesc.
  ///
  /// In pt, this message translates to:
  /// **'Criativo e bem-humorado (moderado).'**
  String get toneFunnyDesc;

  /// No description provided for @ai.
  ///
  /// In pt, this message translates to:
  /// **'IA'**
  String get ai;

  /// No description provided for @catalogConfig.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciamento do catálogo'**
  String get catalogConfig;

  /// No description provided for @catalogConfigDescription.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar catálogo para exibição e venda com clientes'**
  String get catalogConfigDescription;

  /// No description provided for @short.
  ///
  /// In pt, this message translates to:
  /// **'Curto'**
  String get short;

  /// No description provided for @medium.
  ///
  /// In pt, this message translates to:
  /// **'Médio'**
  String get medium;

  /// No description provided for @detailed.
  ///
  /// In pt, this message translates to:
  /// **'Detalhado'**
  String get detailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
