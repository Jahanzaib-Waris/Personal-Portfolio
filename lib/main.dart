import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const DevProfileApp());
}

// ─── Color Palette ───────────────────────────────────────────────────────────
class AppColors {
  static const background = Color(0xFF0D1B2A); // deep navy
  static const surface = Color(0xFF152236); // card surface
  static const surfaceAlt = Color(0xFF1A2C42); // lighter surface
  static const primary = Color(0xFF263B6A); // brand blue
  static const accent = Color(0xFF4A9EFF); // bright accent blue
  static const accentGlow = Color(0x334A9EFF); // glow tint
  static const highlight = Color(0xFF7EC8E3); // light cyan-blue
  static const textPrimary = Color(0xFFE8F1FF);
  static const textSecondary = Color(0xFF8BA3BF);
  static const divider = Color(0xFF1E3350);
  static const chipBg = Color(0xFF1C3354);
}

// ─── App Root ─────────────────────────────────────────────────────────────────
class DevProfileApp extends StatelessWidget {
  const DevProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Developer Profile',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ),
        fontFamily:
            'Courier', // monospace feel – swap to GoogleFonts if available
      ),
      home: const ProfilePage(),
    );
  }
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Subtle grid / dot background
          const Positioned.fill(child: _GridBackground()),

          SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 840),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Column(
                  children: [
                    SizedBox(height: 60),
                    _HeroSection(),
                    SizedBox(height: 56),
                    _SectionDivider(),
                    SizedBox(height: 40),
                    _AboutSection(),
                    SizedBox(height: 40),
                    _SectionDivider(),
                    SizedBox(height: 40),
                    _SkillsSection(),
                    SizedBox(height: 40),
                    _SectionDivider(),
                    SizedBox(height: 40),
                    _ProjectsSection(),
                    SizedBox(height: 40),
                    _SectionDivider(),
                    SizedBox(height: 40),
                    _ConnectSection(),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Grid Background ──────────────────────────────────────────────────────────
class _GridBackground extends StatelessWidget {
  const _GridBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF162236)
      ..strokeWidth = 0.6;
    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // corner glow circle
    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [AppColors.accentGlow, Colors.transparent],
          ).createShader(
            Rect.fromCircle(center: Offset(size.width * 0.5, 0), radius: 350),
          );
    canvas.drawCircle(Offset(size.width * 0.5, 0), 350, glowPaint);
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

// ─── Section Divider ─────────────────────────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, AppColors.accent.withOpacity(0.5)],
            ),
          ),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.6),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String number;
  final String title;

  const _SectionLabel({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.accent,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: Container(height: 1, color: AppColors.divider)),
      ],
    );
  }
}

// ─── Glass Card ───────────────────────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool showAccentBar;

  const _GlassCard({
    required this.child,
    this.padding,
    this.showAccentBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.accent.withOpacity(0.04),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (showAccentBar)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.accent, AppColors.highlight],
                    ),
                  ),
                ),
              ),
            Padding(padding: padding ?? const EdgeInsets.all(24), child: child),
          ],
        ),
      ),
    );
  }
}

// ─── HERO SECTION ─────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with glowing ring
        Stack(
          alignment: Alignment.center,
          children: [
            // outer glow ring
            Container(
              width: 148,
              height: 148,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.35),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
                gradient: SweepGradient(
                  colors: [
                    AppColors.accent,
                    AppColors.highlight,
                    AppColors.primary,
                    AppColors.accent,
                  ],
                ),
              ),
            ),
            // white gap ring
            Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
              ),
            ),
            // avatar
            CircleAvatar(
              radius: 66,
              backgroundColor: AppColors.surfaceAlt,
              // TODO: replace with real asset → backgroundImage: AssetImage("assets/images/profilePhoto.jpeg"),
              child: const Icon(
                Icons.person,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Badge pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentGlow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.8),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Available for work',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.accent,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Name
        const Text(
          'Jahanzaib Waris', // ← YOUR NAME
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 10),

        // Title with gradient
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.accent, AppColors.highlight],
          ).createShader(bounds),
          child: const Text(
            'Flutter / FlutterFlow Developer', // ← YOUR TITLE
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 28),

        // Stats row
        _GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _StatItem(value: '2+', label: 'Years Exp.'), // ← edit
              _StatDivider(),
              _StatItem(value: '10+', label: 'Projects'), // ← edit
              _StatDivider(),
              _StatItem(value: '100%', label: 'Dedication'),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.accent, AppColors.highlight],
          ).createShader(b),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, AppColors.divider, Colors.transparent],
        ),
      ),
    );
  }
}

// ─── ABOUT SECTION ────────────────────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(number: '01', title: 'About'),
        const SizedBox(height: 20),
        _GlassCard(
          showAccentBar: true,
          padding: const EdgeInsets.fromLTRB(28, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who I Am',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                // ← EDIT YOUR BIO
                'Passionate Flutter developer focused on building beautiful, '
                'performant mobile and web experiences. I enjoy crafting clean UI, '
                'solving real-world problems, and continuously sharpening my '
                'engineering skills one commit at a time.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.75,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: const [
                  _InfoChip(
                    icon: Icons.location_on_outlined,
                    label: 'Pakistan',
                  ), // ← edit
                  _InfoChip(
                    icon: Icons.school_outlined,
                    label: 'Computer Science',
                  ), // ← edit
                  _InfoChip(
                    icon: Icons.language,
                    label: 'English / Urdu',
                  ), // ← edit
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─── SKILLS SECTION ───────────────────────────────────────────────────────────
class _SkillsSection extends StatelessWidget {
  const _SkillsSection();

  @override
  Widget build(BuildContext context) {
    final skills = [
      _Skill(
        'Flutter',
        Icons.phone_android,
        0.90,
      ), // ← add/edit skills & proficiency
      _Skill('Dart', Icons.code, 0.85),
      _Skill('Firebase', Icons.local_fire_department, 0.75),
      _Skill('Git', Icons.merge_type, 0.80),
      _Skill('REST APIs', Icons.cloud_queue, 0.70),
      _Skill('UI Design', Icons.brush_outlined, 0.65),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(number: '02', title: 'Skills'),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 260,
            childAspectRatio: 2.4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: skills.length,
          itemBuilder: (_, i) => _SkillTile(skill: skills[i]),
        ),
      ],
    );
  }
}

class _Skill {
  final String name;
  final IconData icon;
  final double level;
  const _Skill(this.name, this.icon, this.level);
}

class _SkillTile extends StatelessWidget {
  final _Skill skill;
  const _SkillTile({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentGlow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(skill.icon, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  skill.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: skill.level,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.accent,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PROJECTS SECTION ─────────────────────────────────────────────────────────
class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection();

  @override
  Widget build(BuildContext context) {
    const projects = [
      _ProjectData(
        tag: 'Mobile',
        title: 'Profile Card App', // ← edit
        description:
            'A Flutter app that showcases a developer profile card '
            'with clean UI components and Material 3 design.',
        tech: ['Flutter', 'Dart', 'Material 3'],
      ),
      _ProjectData(
        tag: 'Productivity',
        title: 'Todo App', // ← edit
        description:
            'Task manager built with Flutter featuring CRUD operations, '
            'local persistence, and a minimal dark UI.',
        tech: ['Flutter', 'SQLite', 'Provider'],
      ),
      // ← ADD MORE PROJECTS HERE
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(number: '03', title: 'Projects'),
        const SizedBox(height: 20),
        ...projects.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ProjectCard(data: p),
          ),
        ),
      ],
    );
  }
}

class _ProjectData {
  final String tag;
  final String title;
  final String description;
  final List<String> tech;

  const _ProjectData({
    required this.tag,
    required this.title,
    required this.description,
    required this.tech,
  });
}

class _ProjectCard extends StatelessWidget {
  final _ProjectData data;
  const _ProjectCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentGlow,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  data.tag.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.accent,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              // TODO: link icon → add GestureDetector with url_launcher
              const Icon(
                Icons.open_in_new,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.tech.map((t) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.chipBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  t,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.highlight,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── CONNECT SECTION ──────────────────────────────────────────────────────────
class _ConnectSection extends StatelessWidget {
  const _ConnectSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(number: '04', title: 'Connect'),
        const SizedBox(height: 20),
        _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let's work together",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Open to freelance, collaborations, or full-time opportunities.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _SocialButton(
                    label: 'GitHub',
                    icon: Icons.code,
                    // TODO: add url
                  ),
                  _SocialButton(
                    label: 'LinkedIn',
                    icon: Icons.work_outline,
                    isPrimary: true,
                    // TODO: add url
                  ),
                  _SocialButton(
                    label: 'Email',
                    icon: Icons.mail_outline,
                    // TODO: add url
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;

  const _SocialButton({
    required this.label,
    required this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: Icon(icon, size: 17),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            // TODO: launch URL
          },
        ),
      );
    }

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.divider),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.surfaceAlt,
      ),
      icon: Icon(icon, size: 17, color: AppColors.accent),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onPressed: () {
        // TODO: launch URL
      },
    );
  }
}
