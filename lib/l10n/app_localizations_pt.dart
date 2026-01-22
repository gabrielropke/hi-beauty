// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get language => 'Idioma';

  @override
  String get createAccountAgreement =>
      'Ao criar uma conta você concorda com os';

  @override
  String get termsOfUse => 'Termos de Uso';

  @override
  String get and => 'e';

  @override
  String get hi => 'Olá';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get moveAndResize => 'Mover e redimensionar';

  @override
  String get save => 'Salvar';

  @override
  String get next => 'Próximo';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get back => 'Voltar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get select => 'Selecione';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get or => 'Ou';

  @override
  String get continueWithGoogle => 'Entrar com Google';

  @override
  String get name => 'Nome completo';

  @override
  String get whatsapp => 'Whatsapp';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get whatsappHint => '(11) 99999-9999';

  @override
  String get typeHere => 'Digite aqui...';

  @override
  String get nameHint => 'Digite seu nome completo';

  @override
  String get emailHint => 'Insira seu endereço de e-mail';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get forgotPassword => 'Esqueci minha senha';

  @override
  String get entry => 'Entrar';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get clickHere => 'Clique aqui';

  @override
  String get registerToAccount => 'Criar uma conta';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get registerToAccountDescription =>
      'Crie uma conta com seu e-mail ou sua conta Google e experimente a plataforma gratuitamente.';

  @override
  String get loginToAccount => 'Acesse sua conta';

  @override
  String get min6Chars => 'Mínimo de 6 caracteres';

  @override
  String get oneUppercase => '1 letra maiúscula';

  @override
  String get oneLowercase => '1 letra minúscula';

  @override
  String get oneSpecialChar => '1 caracter especial';

  @override
  String get verifyEmail => 'Verifique seu e-mail';

  @override
  String get invalidCode => 'Código inválido';

  @override
  String resendCodeTimer(Object segundos) {
    return 'Reenviar código em $segundos segundo';
  }

  @override
  String get resendCode => 'Reenviar código';

  @override
  String verifyEmailDescription(Object email) {
    return 'Enviamos um e-mail para $email com o código de confirmação. Acesse sua caixa para conferir o código e insira abaixo:';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get incorrectUser => 'E-mail ou senha inválidos.';

  @override
  String get howGetHere => 'Como nos encontrou?';

  @override
  String get forgotPasswordTitle => 'Esqueceu a senha?';

  @override
  String get forgotPasswordDescription =>
      'Se você já tem uma conta cadastrada com o e-mail informado, você receberá uma mensagem na sua caixa de entrada para redefinir sua senha. Caso não receba, verifique a caixa de spam';

  @override
  String get resetPassword => 'Redefinir senha';

  @override
  String get forgotEmailInvalid => 'Este e-mail não está registrado';

  @override
  String get yourBusiness => 'Seu negócio';

  @override
  String get yourBusinessDescription =>
      'Preencha os dados abaixo para registrar seu negócio e começar a suar gratuitamente.';

  @override
  String get yourBusinessName => 'Nome do negócio';

  @override
  String get yourBusinessNametitle => 'Qual é o nome do seu\nnegócio?';

  @override
  String get yourBusinessNameHint => 'Ex: Negócio da Maria';

  @override
  String get slugHint => 'negocio-da-maria';

  @override
  String get slugDescription => 'Seus clientes acessarão: hibeauty.co/seu-link';

  @override
  String get moreSelection => 'Selecione uma ou mais';

  @override
  String get createYourLink => 'Crie seu link';

  @override
  String get segmentBusiness => 'Segmento de atuação';

  @override
  String get segmentBusinessDescription =>
      'Selecione a categoria que melhor descreve o seu negócio. Isso nos ajudará a criar uma melhor experiência para você!';

  @override
  String get subSegments => 'Especialidades';

  @override
  String get subSegmentBusiness =>
      'Selecione uma ou mais especialidades do seu negócio';

  @override
  String get yourBusinessSizeTeam => 'Tamanho da equipe';

  @override
  String get onlyLowercaseAndNumbers => 'Somente letras minúsculas e números';

  @override
  String get yourBusinessIndustryHint =>
      'Seleciona a opção que melhor descreva a sua atividade';

  @override
  String get informationEditedInTheFuture =>
      'Estas informações podem ser editadas a qualquer momento no menu de configurações';

  @override
  String get configAccount => 'Configurações da conta';

  @override
  String get initial => 'Início';

  @override
  String get business => 'Negócio';

  @override
  String get notifications => 'Notificações';

  @override
  String get site => 'Site';

  @override
  String get gallery => 'Galeria';

  @override
  String get camera => 'Câmera';

  @override
  String get appointments => 'Agendamentos';

  @override
  String get myAppointments => 'Meus agendamentos';

  @override
  String get myProfile => 'Meu perfil';

  @override
  String get clients => 'Clientes';

  @override
  String get myBusiness => 'Meu negócio';

  @override
  String get myBusinessDescription =>
      'Gerencie as informações do seu negócio e mantenha seus dados sempre atualizados, essas informações estarão disponíveis no seu site';

  @override
  String get your => 'Clientes';

  @override
  String get yourBusinessSubtitle => 'Fale sobre seu negócio';

  @override
  String get address => 'Endereço';

  @override
  String get addressEdit => 'Editar seu local';

  @override
  String get businessAddress => 'Onde está localizada o seu negócio?';

  @override
  String get insertToContinue =>
      'Preenche o campo acima para continuar o cadastro';

  @override
  String get district => 'Bairro';

  @override
  String get city => 'Cidade';

  @override
  String get state => 'Estado';

  @override
  String get contact => 'Contato';

  @override
  String get zipcode => 'CEP';

  @override
  String get number => 'Número';

  @override
  String get complement => 'Complemento';

  @override
  String get resetPasswordSuccess => 'Senha alterada com sucesso!';

  @override
  String get messageSuccess => 'Alterações salvas com sucesso!';

  @override
  String get insertImageHint =>
      'Clique para inserir uma logo para a seu negócio';

  @override
  String get personalData => 'Informações pessoais';

  @override
  String get businessData => 'Informações do negócio';

  @override
  String get dataNull => 'Complete seu cadastro';

  @override
  String get dataNullDescription =>
      'Complete seu cadastro preenchendo as informações solicitadas abaixo';

  @override
  String get businessDataDescription =>
      'Preencha os dados abaixo para criar sua conta.';

  @override
  String get descriptionBusiness => 'Sobre o negócio';

  @override
  String get customizeIdentify => 'Customize sua identidade';

  @override
  String get insertImageAndCoverImage => 'Insira as imagens da sua marca';

  @override
  String get optional => 'Opcional';

  @override
  String get favoriteColor => 'Qual é a cor do seu negócio?';

  @override
  String get favoriteColorDescription =>
      'A cor escolhida será utilizando na sua marca e vista pelos seus clientes';

  @override
  String get logo => 'Logo';

  @override
  String get background => 'Capa do seu negócio';

  @override
  String get instagram => 'Instagram';

  @override
  String get instagramHint => 'seu_instagram';

  @override
  String get todayIs => 'Hoje é';

  @override
  String get customer => 'Cliente';

  @override
  String get customersList => 'Lista de clientes';

  @override
  String get searchCurstomersHint => 'Nome, e-mail ou telefone...';

  @override
  String get customersListDescription => 'Gerencie os clientes do seu negócio.';

  @override
  String get add => 'Adicionar';

  @override
  String get filters => 'Filtros';

  @override
  String get moreRecent => 'Mais recentes';

  @override
  String get moreOld => 'Mais antigos';

  @override
  String get you => 'Você';

  @override
  String get customerExemplo => 'Cliente exemplo';

  @override
  String get completeSetup => 'Finalize o cadastro do seu negócio';

  @override
  String get businessCardOptionData => 'Dados cadastrais';

  @override
  String get businessCardOptionTeam => 'Equipe';

  @override
  String get businessCardOptionReviews => 'Avaliações';

  @override
  String get businessCardOptionClients => 'Clientes';

  @override
  String get businessCardOptionServices => 'Catálogo';

  @override
  String get businessCardOptionMyTeam => 'Minha equipe';

  @override
  String get mySite => 'Meu site';

  @override
  String get customize => 'Customização';

  @override
  String get visual => 'Visual';

  @override
  String get brandColor => 'Cor da marca';

  @override
  String get previewColor => 'Preview da cor';

  @override
  String get principalColor => 'Cor principal';

  @override
  String get brandImage => 'Logo do negócio';

  @override
  String get brandCoverImage => 'Capa do site';

  @override
  String get brandImageReccomendation => 'Recomendado: 400x400px, PNG/JPG';

  @override
  String get brandCoverImageReccomendatio => 'Recomendado: 1200x400px, PNG/JPG';

  @override
  String get customizeDescription => 'Personalize a aparência do seu site';

  @override
  String get businessDataSubtitle => 'Informações essenciais do seu negócio';

  @override
  String get customizeSubtitle => 'Personalização visual do seu site';

  @override
  String get whatsappSubtitle => 'Conectar para comunicação com clientes';

  @override
  String get addressSubtitle => 'Localização do seu estabelecimento';

  @override
  String get progress => 'Progresso';

  @override
  String get connect => 'Conectar';

  @override
  String get discconnect => 'Desconectar';

  @override
  String get principal => 'Principal';

  @override
  String get inDevelopment => 'Em breve';

  @override
  String get businessSectionConfig => 'Configuração do Negócio';

  @override
  String get businessSectionConfigDescription =>
      'Complete as 4 etapas para ativar todas as funcionalidades';

  @override
  String get businessConfig => 'Configurações do ambiente de trabalho';

  @override
  String get businessConfigDescription => 'Gerenciar configurações para';

  @override
  String get editBusiness => 'Editar dados do negócio';

  @override
  String get editBusinessDescription =>
      'Escolha os dados do seu negócio que serão utilizados como perfil da empresa, e exibidos em recibos de vendas ou mensagens.';

  @override
  String get schedule => 'Agendar';

  @override
  String get time => 'Horário';

  @override
  String get profile => 'Perfil';

  @override
  String get themeColor => 'Cor tema';

  @override
  String get teamMembers => 'Colaboradores';

  @override
  String get collaboratorPhoto => 'Foto do(a) colaborador(a)';

  @override
  String get roleAndFunction => 'Cargo e função';

  @override
  String get roleAndCustomizationSettings =>
      'Definições de cargo e personalização';

  @override
  String get status => 'Status';

  @override
  String get lastUpdate => 'Última atualização';

  @override
  String get actions => 'Ações';

  @override
  String get searchTeams => 'Pesquisar colaboradores';

  @override
  String get owner => 'Proprietário';

  @override
  String get manager => 'Gerente';

  @override
  String get employee => 'Funcionário';

  @override
  String get freelancer => 'Freelancer';

  @override
  String get active => 'Ativo';

  @override
  String get inactive => 'Inativo';

  @override
  String get suspended => 'Suspenso';

  @override
  String get onVacation => 'Em férias';

  @override
  String get sortBy => 'Classificar por';

  @override
  String get clear => 'Limpar';

  @override
  String get apply => 'Aplicar';

  @override
  String get profileEditDescription =>
      'Gerenciar o perfil pessoal dos colaboradores';

  @override
  String get businessHours => 'Horários de funcionamento';

  @override
  String get businessHoursDescription =>
      'Configure os horários do seu negócio e colaboradores';

  @override
  String get businessSchedule => 'Horários do Negócio';

  @override
  String get addCollaborator => 'Adicionar colaborador(a)';

  @override
  String get scheduledShifts => 'Turnos programados';

  @override
  String get team => 'Equipe';

  @override
  String get week => 'Semana';

  @override
  String get rulesTitle => 'Regras de Agendamento';

  @override
  String get rulesSubtitle =>
      'Configure como seus clientes podem fazer agendamentos';

  @override
  String get scheduleSettingsTitle => 'Configurações de Horário';

  @override
  String get scheduleSettingsSubtitle =>
      'Defina intervalos e prazos para agendamentos';

  @override
  String get timeIntervalLabel => 'Intervalo entre horários disponíveis';

  @override
  String get timeIntervalOption15min => 'A cada 15 minutos';

  @override
  String get timeIntervalDescription =>
      'Define o espaçamento entre horários disponíveis na agenda';

  @override
  String get minAdvanceLabel => 'Antecedência mínima para agendamento';

  @override
  String get minAdvanceHours => 'horas';

  @override
  String get minAdvanceDescription =>
      'Clientes podem agendar a qualquer momento';

  @override
  String get bookingWindowLabel => 'Janela de agendamento';

  @override
  String get bookingWindowDays => 'dias';

  @override
  String get bookingWindowDescription =>
      'Até quantos dias no futuro os clientes podem agendar';

  @override
  String get cancellationSectionTitle => 'Cancelamento e Reagendamento';

  @override
  String get cancellationSectionSubtitle =>
      'Configure políticas de alteração de agendamentos';

  @override
  String get allowRescheduleLabel => 'Permitir reagendamento';

  @override
  String get allowRescheduleDescription =>
      'Clientes podem alterar data e horário dos agendamentos';

  @override
  String get allowCancelLabel => 'Permitir cancelamento';

  @override
  String get allowCancelDescription => 'Clientes podem cancelar agendamentos';

  @override
  String get minCancelTimeLabel => 'Prazo mínimo para cancelamento';

  @override
  String get minCancelTimeHours => 'horas';

  @override
  String get minCancelTimeDescription =>
      'Cancelamentos devem ser feitos com 0 min de antecedência';

  @override
  String get loginToAccountDescription =>
      'Faça login com seu e-mail ou sua conta google';

  @override
  String get approvalTitle => 'Aprovação de Agendamentos';

  @override
  String get approvalSubtitle =>
      'Configure se agendamentos precisam de aprovação manual';

  @override
  String get requireManualApprovalLabel => 'Requer aprovação manual';

  @override
  String get requireManualApprovalDescription =>
      'Agendamentos ficam pendentes até serem aprovados';

  @override
  String get clientLimitsTitle => 'Limites por Cliente';

  @override
  String get clientLimitsSubtitle =>
      'Configure quantos agendamentos cada cliente pode fazer';

  @override
  String get multiplePerDayLabel => 'Múltiplos agendamentos por dia';

  @override
  String get multiplePerDayDescription =>
      'Permitir mais de um agendamento por cliente no mesmo dia';

  @override
  String get holidayBookingsLabel => 'Agendamentos em feriados';

  @override
  String get holidayBookingsDescription =>
      'Permitir agendamentos em feriados nacionais';

  @override
  String get dailyLimitLabel => 'Limite diário por cliente (0 = ilimitado)';

  @override
  String get currentValueLabel => 'Atual:';

  @override
  String get unlimitedLabel => 'Ilimitado';

  @override
  String get onePerDayLabel => '1 por dia';

  @override
  String get perDaySuffix => 'por dia';

  @override
  String get termsConditionsTitle => 'Termos e Condições';

  @override
  String get termsConditionsSubtitle =>
      'Configure termos que o cliente deve aceitar ao agendar';

  @override
  String get requireTermsLabel => 'Exigir aceitação de termos';

  @override
  String get requireTermsDescription =>
      'Cliente deve aceitar termos antes de finalizar agendamento';

  @override
  String get whatsappNumber => 'Número do WhatsApp';

  @override
  String get enterNumberToGenerateCode => 'Digite o número para gerar o código';

  @override
  String get aiSettings => 'Configurações de IA';

  @override
  String get connectWhatsappToEditPersonality =>
      'Conecte o WhatsApp para editar a personalidade';

  @override
  String minCancelTimeDynamic(Object minutes) {
    return 'Cancelamentos devem ser feitos com $minutes min de antecedência';
  }

  @override
  String get tone => 'Tom';

  @override
  String get verbosity => 'Verbosidade';

  @override
  String get whatsappConnected =>
      'WhatsApp conectado. Assistente inteligente ativo.';

  @override
  String get personalityStyle => 'Personalidade & Estilo';

  @override
  String get advancedFeatures => 'Recursos Avançados';

  @override
  String get autoScheduling => 'Agendamento Automático';

  @override
  String get autoSchedulingDesc => 'Sugere horários livres';

  @override
  String get smartUpsell => 'Upsell Inteligente';

  @override
  String get smartUpsellDesc => 'Sugestões de serviços extras';

  @override
  String get longTexts => 'Textos Longos';

  @override
  String get longTextsDesc => 'Interpreta contexto extenso';

  @override
  String get audios => 'Áudios (PT-BR)';

  @override
  String get audiosDesc => 'Transcreve e entende intenção';

  @override
  String get smartFollowUp => 'Follow-up Inteligente';

  @override
  String get smartFollowUpDesc => 'Perguntas relevantes adicionais';

  @override
  String get multiLanguage => 'Multi-Idioma';

  @override
  String get multiLanguageDesc => 'Detecta e responde';

  @override
  String get audioSupportedNote =>
      'Áudio suportado inicialmente em Português (Brasil).';

  @override
  String get aiPersonalityAdjust =>
      'Ajuste como a IA conversa com seus clientes';

  @override
  String get generatedExample => 'Exemplo gerado';

  @override
  String get exampleFriendly1 =>
      'Opa! Tudo joia? Posso reservar pra você amanhã às 15h, confirmo agora ou prefere outro horário?';

  @override
  String get exampleProfessional =>
      'Olá. Posso proceder com o agendamento amanhã às 15h, confirmo agora ou prefere outro horário?';

  @override
  String get exampleCasual =>
      'E aí! Bora marcar isso rapidinho amanhã às 15h, confirmo agora ou prefere outro horário?';

  @override
  String get exampleFormal =>
      'Prezada(o), posso efetivar o agendamento amanhã às 15h, confirmo agora ou prefere outro horário?';

  @override
  String get exampleFunny =>
      'E aí, estiloso! Vamos garantir aquele corte top amanhã às 15h, confirmo agora ou prefere outro horário?';

  @override
  String get selected => 'Selecionado';

  @override
  String get toneFriendly => 'Amigável';

  @override
  String get toneProfessional => 'Profissional';

  @override
  String get toneCasual => 'Descontraído';

  @override
  String get toneFormal => 'Formal';

  @override
  String get toneFunny => 'Engraçado';

  @override
  String get quickToneGuide => 'Guia rápido de tom';

  @override
  String get toneFriendlyDesc => 'Acolhedor, aproxima e gera confiança.';

  @override
  String get toneProfessionalDesc => 'Objetivo, seguro e direto ao ponto.';

  @override
  String get toneCasualDesc => 'Leve, casual, cria proximidade rapidamente.';

  @override
  String get toneFormalDesc => 'Neutro, respeitoso e adequado a todos.';

  @override
  String get toneFunnyDesc => 'Criativo e bem-humorado (moderado).';

  @override
  String get ai => 'IA';

  @override
  String get catalogConfig => 'Gerenciamento do catálogo';

  @override
  String get catalogConfigDescription =>
      'Gerenciar catálogo para exibição e venda com clientes';

  @override
  String get short => 'Curto';

  @override
  String get medium => 'Médio';

  @override
  String get detailed => 'Detalhado';
}
