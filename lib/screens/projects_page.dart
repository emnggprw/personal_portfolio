import 'package:flutter/material.dart';
import 'package:personal_portfrolio/models/project_card.dart';
import 'package:personal_portfrolio/utils/constants.dart';
import 'package:personal_portfrolio/widgets/animated_header.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int crossAxisCount = constraints.maxWidth > 1000
              ? 3
              : constraints.maxWidth > 600
              ? 2
              : 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnimatedHeader('My Projects'),
              const SizedBox(height: 16),
              GridView.builder(
                itemCount: projects.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ProjectCard(
                    title: project['title']!,
                    description: project['description']!,
                    assetImagePath: project['assetImagePath']!,
                    techStack: project['techStack']!,
                    projectUrl: project['projectUrl']!,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
