import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/constants/app_images.dart';
import 'package:hibeauty/theme/app_colors.dart';

Future<void> showWelcomeTutorialSheet({required BuildContext context}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => WelmoceTutorial(),
  );
}

class WelmoceTutorial extends StatefulWidget {
  const WelmoceTutorial({super.key});

  @override
  State<WelmoceTutorial> createState() => _WelmoceTutorialState();
}

class _WelmoceTutorialState extends State<WelmoceTutorial> {
  final PageController _pageController = PageController();
  int currentStep = 0;

  final List<Map<String, dynamic>> tutorialSteps = [
    {
      'image': AppImages.welcomeCalendarTutorial,
      'title': 'Como agendar pelo app?',
      'description':
          'Selecione um horário disponivel no calendário para agendar ou clique no botão "+" para ver as opções.',
    },
    {
      'image': AppImages.welcomeTutorialBusiness,
      'title': 'Sobre o seu negócio',
      'description':
          'Não se esqueça de configurar as informações do seu negócio, para melhor experiência.',
    },
    {
      'image': AppImages.welcomeTutorialTeam,
      'title': 'Entenda sua equipe',
      'description':
          'Você pode distribuir sua equipe em horários, facilitando o gerenciamento dos seus colaboradores.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                itemCount: tutorialSteps.length,
                itemBuilder: (context, index) => _buildTutorialPage(context, index),
              ),
            ),
            _buildIndicators(),
            _buildBottomButton(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialPage(BuildContext context, int index) {
    final step = tutorialSteps[index];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(160),
            ),
            child: Image.asset(
              step['image'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 280,
            ),
          ),
          SizedBox(height: 20),
          Text(
            step['title'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              step['description'],
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          tutorialSteps.length,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: currentStep == index ? 24 : 8,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: currentStep == index ? AppColors.secondary : Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: AppButton(
        mainAxisSize: MainAxisSize.min,
        padding: EdgeInsets.symmetric(horizontal: 25),
        height: 44,
        label: currentStep == tutorialSteps.length - 1
            ? 'Começar a usar agora!'
            : 'Próximo',
        function: () {
          if (currentStep == tutorialSteps.length - 1) {
            // Último step - fechar modal
            context.pop();
          } else {
            _pageController.nextPage(
              duration: Duration(milliseconds: 1200),
              curve: Curves.easeOutExpo,
            );
          }
        },
      ),
    );
  }

}
