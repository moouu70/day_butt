import 'package:flutter/material.dart';
import '../models/effective_theme.dart';

/// Helper model encapsulating visual attributes for an individual theme profile.
class _ThemeProfileData {
  final String visualIdentity;
  final String colorRoleGuidance;
  final String colorDistribution;
  final String mood;
  final String lighting;
  final String atmosphere;
  final String materials;
  final String environment;
  final String visualMotifs;
  final String artDirection;
  final String composition;
  final String uiCompatibility;
  final String imageRequirements;
  final String avoid;

  const _ThemeProfileData({
    required this.visualIdentity,
    required this.colorRoleGuidance,
    required this.colorDistribution,
    required this.mood,
    required this.lighting,
    required this.atmosphere,
    required this.materials,
    required this.environment,
    required this.visualMotifs,
    required this.artDirection,
    required this.composition,
    required this.uiCompatibility,
    required this.imageRequirements,
    required this.avoid,
  });
}

/// Service responsible for dynamically extracting the visual DNA of any
/// [EffectiveTheme] into a platform-agnostic, AI-ready prompt foundation.
class ThemeDnaFormatter {
  ThemeDnaFormatter._();

  static const String wallpaperRequestPlaceholder =
      '[DESCRIBE THE WALLPAPER / SCENE YOU WANT TO GENERATE HERE]';

  /// Converts a [Color] into a standard 6-digit uppercase hex code string (e.g., `#7657FF`).
  static String colorToHex(Color color) {
    final hex = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return '#${hex.substring(2)}';
  }

  /// Generates the complete, AI-ready Theme DNA text representation.
  static String format(EffectiveTheme theme) {
    final colors = theme.colors;
    final primaryHex = colorToHex(colors.primary);
    final secondaryHex = colorToHex(colors.secondary);
    final highlightHex = colorToHex(colors.highlight);
    final bgHex = colorToHex(colors.background);
    final deepBgHex = colorToHex(colors.backgroundDeep);
    final surfaceHex = colorToHex(colors.surface);
    final textPrimaryHex = colorToHex(colors.textPrimary);
    final textSecondaryHex = colorToHex(colors.textSecondary);

    final profile = _resolveProfile(theme);
    final themeDisplayName = theme.name.toUpperCase();

    final buffer = StringBuffer();
    buffer.writeln('DAY BUTT — $themeDisplayName');
    buffer.writeln('THEME DNA');
    buffer.writeln();
    buffer.writeln('WALLPAPER REQUEST:');
    buffer.writeln();
    buffer.writeln(wallpaperRequestPlaceholder);
    buffer.writeln();
    buffer.writeln('--------------------------------------------------');
    buffer.writeln();
    buffer.writeln('THEME VISUAL DNA');
    buffer.writeln();
    buffer.writeln('Visual Identity:');
    buffer.writeln(profile.visualIdentity);
    buffer.writeln();
    buffer.writeln('Color Palette:');
    buffer.writeln('Primary: $primaryHex');
    buffer.writeln('Secondary: $secondaryHex');
    buffer.writeln('Highlight: $highlightHex');
    buffer.writeln('Background: $bgHex');
    buffer.writeln('Deep Background: $deepBgHex');
    buffer.writeln('Surface: $surfaceHex');
    buffer.writeln('Text Primary: $textPrimaryHex');
    buffer.writeln('Text Secondary: $textSecondaryHex');
    buffer.writeln();
    buffer.writeln('Color Application:');
    buffer.writeln(profile.colorRoleGuidance);
    buffer.writeln();
    buffer.writeln('Color Distribution:');
    buffer.writeln(profile.colorDistribution);
    buffer.writeln();
    buffer.writeln('Mood:');
    buffer.writeln(profile.mood);
    buffer.writeln();
    buffer.writeln('Lighting:');
    buffer.writeln(profile.lighting);
    buffer.writeln();
    buffer.writeln('Atmosphere:');
    buffer.writeln(profile.atmosphere);
    buffer.writeln();
    buffer.writeln('Materials:');
    buffer.writeln(profile.materials);
    buffer.writeln();
    buffer.writeln('Environment:');
    buffer.writeln(profile.environment);
    buffer.writeln();
    buffer.writeln('Visual Motifs:');
    buffer.writeln(profile.visualMotifs);
    buffer.writeln();
    buffer.writeln('Art Direction:');
    buffer.writeln(profile.artDirection);
    buffer.writeln();
    buffer.writeln('Composition:');
    buffer.writeln(profile.composition);
    buffer.writeln();
    buffer.writeln('UI Compatibility:');
    buffer.writeln(profile.uiCompatibility);
    buffer.writeln();
    buffer.writeln('Image Requirements:');
    buffer.writeln(profile.imageRequirements);
    buffer.writeln();
    buffer.writeln('Avoid:');
    buffer.writeln(profile.avoid);
    buffer.writeln();
    buffer.writeln('--------------------------------------------------');
    buffer.writeln();
    buffer.writeln('GENERATION INSTRUCTION');
    buffer.writeln();
    buffer.writeln(
      'Generate the wallpaper described in WALLPAPER REQUEST while following the THEME VISUAL DNA.',
    );
    buffer.writeln(
      'The wallpaper should feel like it belongs to the same visual world as the DAY BUTT ${theme.name} theme.',
    );

    return buffer.toString().trim();
  }

  static _ThemeProfileData _resolveProfile(EffectiveTheme theme) {
    final id = theme.basePreset.id.toLowerCase();
    switch (id) {
      case 'midnight':
        return const _ThemeProfileData(
          visualIdentity:
              'Quiet, contemplative neo-noir cityscape seen from high above the world, punctuated by indigo shadows, cool electric violet reflections, and sleek metropolitan glass towers against deep obsidian.',
          colorRoleGuidance:
              'Electric violet as architectural edge lighting and horizon luminescence; cobalt blue as atmospheric haze and distant reflections; lavender as pinpoint specular lights; obsidian and pitch black as dominant background voids.',
          colorDistribution:
              '70–75% deep dark tones, 15–20% atmospheric midtones, 5–7% primary electric violet accent, 2–3% highlight.',
          mood:
              'Introspective, solitary, ultra-modern, cerebral focus; deep night (02:30 AM). Cold night air with localized electric warmth.',
          lighting:
              'Cool ambient indigo night with subtle electric violet edge lighting skimming architectural mullions, soft distant city point lights blurred through cold atmosphere.',
          atmosphere:
              'Still, quiet nocturnal metropolis, low-key cinematic luxury, rain-slicked clarity, deep acoustic hush.',
          materials:
              'Dark tinted architectural glass, matte brushed dark steel, wet obsidian pavement, anodized aluminum frames, translucent acrylic.',
          environment:
              'High-altitude penthouse balcony, quiet rain-slicked city bridge, nocturnal financial district, modern observation lounge.',
          visualMotifs:
              'Geometric skyscraper silhouettes, thin violet horizon gradients, distant city lights blurred by wet glass, quiet nocturnal skyline.',
          artDirection:
              'Cinematic architectural digital realism; clean geometric lines, shallow depth of field, anamorphic atmospheric lighting.',
          composition:
              'Vertical 9:16 mobile framing. Architectural edges frame top and sides; center 50% reserved for deep, dark, low-contrast negative space; bottom grounded by subtle reflective surfaces.',
          uiCompatibility:
              'Maintain deep dark values in the center (luminance below 10%) so translucent glass cards, white text, and progress bars remain perfectly legible.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as a mobile application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Bright daylight, noon sunshine, neon clutter, chaotic graffiti, visible people or faces, harsh contrast in the central viewport, text, interface elements.',
        );

      case 'sakura_night':
        return const _ThemeProfileData(
          visualIdentity:
              'Poetic Kyoto and Tokyo spring night atmosphere with deep night plum skies, wisteria mist, and luminescent cherry blossoms glowing softly under moonlight and paper lanterns.',
          colorRoleGuidance:
              'Vibrant sakura rose on petal silhouettes and rim-lit branches; wisteria purple in night mist and stone reflections; soft blossom pink in floating petal highlights; blackened violet and night plum as nocturnal foundation.',
          colorDistribution:
              '68–72% blackened violet & night plum, 18–22% wisteria & dark velvet midtones, 6–8% vibrant sakura rose, 2–3% soft blossom glow.',
          mood:
              'Poetic, dreamlike, romantic, quiet, serene; blue hour transitioning into midnight spring. Gentle, graceful, floating energy.',
          lighting:
              'Pale silvery moonlight filtering through blossom canopies, balanced by diffused rose-violet glow of washi lanterns; soft water reflections.',
          atmosphere:
              'Gentle, fragrant, floating petals in cool spring air, timeless serenity, delicate nocturnal beauty.',
          materials:
              'Weathered dark Hinoki cedar, washi paper lanterns, smooth river stones, rippling black water, delicate cherry petals, kawara roof tiles.',
          environment:
              'Secluded temple courtyard, traditional Japanese garden at night, wooden canal bridge with blooming boughs, tea pavilion veranda.',
          visualMotifs:
              'Weeping sakura boughs, backlit floating petals, circular washi paper lanterns, rippling water reflections, pagoda silhouettes.',
          artDirection:
              'Cinematic anime-realism with fine photographic lighting; ethereal particle atmosphere, crisp foreground organic silhouettes, soft volumetric moonbeams.',
          composition:
              'Vertical 9:16 mobile composition. Blossoms and lanterns frame top corners and margins; bottom anchored by dark wood decking or reflective pond; central 50% kept open and deep plum-violet.',
          uiCompatibility:
              'Dark velvet background prevents bright blooming petals from obscuring white text; center area has calm, low-frequency mist for glass widgets.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as a mobile application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Harsh neon signs, modern plastic or telephone poles, oversaturated cartoon pink, daylight, visible people, text, calligraphy, UI elements.',
        );

      case 'samurai_night':
      case 'japan':
        return const _ThemeProfileData(
          visualIdentity:
              'Dark, cinematic tribute to feudal Japanese warrior discipline and nocturnal Edo architecture; pitch-black obsidian tones and aged timber pierced by razor-sharp warrior crimson and weathered plum.',
          colorRoleGuidance:
              'Warrior crimson as torii gate lacquer, lantern silk, and autumn maple accents; aged plum as soft midtone mist and tile shadows; amber and blade red as warm lantern ember glow; deep obsidian as disciplined nocturnal space.',
          colorDistribution:
              '72–76% deep obsidian & pitch indigo, 16–20% dark timber & aged plum, 5–7% warrior crimson accent, 2–3% warm lantern ember.',
          mood:
              'Disciplined, solemn, dramatic, sharp, stealthy; midnight under a cold moon (01:00 to 04:00 AM). Restrained, coiled power, intense focus.',
          lighting:
              'Sharp directional moonlight casting hard shadows across timber verandas, concentrated warm crimson/amber glow from oiled-paper lanterns, specular glints on polished lacquer.',
          atmosphere:
              'Crisp mountain night air with charcoal ember warmth, absolute honor, silent martial vigilance.',
          materials:
              'Charred cedar (yakisugi), polished black and red urushi lacquer, forged folded steel, rough granite, coarse tatami, oiled washi paper.',
          environment:
              'Edo period castle fortress, quiet midnight dojo, mountain shrine torii path, fortified samurai residence, misty bamboo grove.',
          visualMotifs:
              'Torii gate silhouettes, black kawara tile roofs, fallen crimson maple leaves (momiji), chochin paper lanterns, bamboo silhouettes.',
          artDirection:
              'Cinematic period realism with Kurosawa-inspired high-contrast lighting; razor-sharp textures, atmospheric mountain mist, physical material grit.',
          composition:
              'Vertical 9:16 mobile composition. Charred timber pillars or bamboo frame vertical borders; curved roofline frames top; center 50% kept dark, clear, and quiet.',
          uiCompatibility:
              'Guaranteed contrast for warm rice-paper white text and crimson buttons; lanterns kept at borders away from central card areas.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as a mobile application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Cartoon anime style, modern neon, modern clothing, bright daylight, pink flowers, blood, violence, people, text, calligraphy, UI elements.',
        );

      case 'deep_ocean':
        return const _ThemeProfileData(
          visualIdentity:
              'Abyssal underwater journey into the silent, weightless midnight depths of the open sea; vast aquatic space, deep cobalt and marine navy shadows, pierced by luminescent cyan bio-light.',
          colorRoleGuidance:
              'Bioluminescent cyan as glowing micro-plankton, siphonophore rim lights, and light shaft refractions; marine cobalt as deep volumetric water rays; pelagic black and midnight navy as infinite aquatic void.',
          colorDistribution:
              '72–76% pelagic black & midnight abyss navy, 16–20% submerged slate & marine cobalt, 5–7% bioluminescent cyan, 2–3% aqua luminescence.',
          mood:
              'Weightless, serene, immense, mysterious, tranquil; perpetual deep twilight abyssal zone. Extremely calm, rhythmic pulse.',
          lighting:
              'Volumetric crepuscular light shafts filtering down through vast depths, dissolving into deep indigo; soft bioluminescent ambient glow from microscopic organisms.',
          atmosphere:
              'Silent, rhythmic, slow-pulsing, immense oceanic depth, pressure-free clarity and tranquility.',
          materials:
              'Clear deep water, submerged basalt sea shelves, coral rock, translucent organic tissue, sea glass, mother-of-pearl.',
          environment:
              'Open pelagic blue water, submerged sea trench, abyssal sea cavern entrance, underwater observatory dome, silent kelp forest canopy.',
          visualMotifs:
              'Ascending micro-bubbles, faint caustic light webs, distant manta silhouettes, bioluminescent trails, volumetric aquatic light shafts.',
          artDirection:
              'Deep-sea oceanic cinematography (James Cameron abyssal aesthetic); volumetric light scattering, pristine liquid transparency, smooth dark gradients.',
          composition:
              'Vertical 9:16 mobile composition. Downward light shafts filter through top 20%; basalt ridges anchor the bottom; central 55% is vast, quiet open water column.',
          uiCompatibility:
              'Submerged navy midtones provide perfect contrast for bright cyan indicators and pearl-white text with zero visual competition.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as a mobile application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Cartoon fish, tropical sunny coral reefs, sunken treasure chests, scuba divers, boats, text, UI elements.',
        );

      case 'night_forest':
        return const _ThemeProfileData(
          visualIdentity:
              'Ancient, nocturnal boreal wilderness with towering evergreen silhouettes, misty moss-covered earth, and deep emerald shadow tones illuminated by drifting golden fireflies and soft pale moonlight.',
          colorRoleGuidance:
              'Emerald green on backlit fern fronds and moss highlights; deep forest teal in misty tree lines and shadows; firefly gold on drifting warm light orbs; obsidian pine black as ground and canopy void.',
          colorDistribution:
              '70–75% abyssal canopy & obsidian pine, 18–22% deep forest teal & moss slate, 5–7% emerald bio-green, 2–3% firefly gold glow.',
          mood:
              'Ancient, grounded, restorative, enchanted, quiet; midnight in a misty northern forest. Cool pine-scented air and fertile earth.',
          lighting:
              'Cool silver moonlight filtering through dense evergreen canopies, volumetric light shafts, warm golden-yellow luminescence from floating fireflies.',
          atmosphere:
              'Grounded natural majesty, cool mountain stillness, moist earth, restorative nocturnal peace.',
          materials:
              'Rough pine bark, damp velvet moss, dark fertile soil, granite boulders, evergreen needles, misty water vapor, translucent fern leaves.',
          environment:
              'Ancient cedar grove, misty mountain clearing, nocturnal riverbank lined with mossy boulders, secluded woodland cabin clearing, towering sequoia canopy.',
          visualMotifs:
              'Tall pine silhouettes, drifting golden firefly orbs, delicate fern fronds, curling mist ribbons, moonbeams through branches, ancient mossy roots.',
          artDirection:
              'Atmospheric cinematic nature photography; shallow depth of field on foreground foliage, volumetric moonlight, organic textures with clean shadow roll-off.',
          composition:
              'Vertical 9:16 mobile composition. Pine trunks flank left and right margins like natural pillars; mossy ground anchors bottom; center 50% is soft, dark forest mist.',
          uiCompatibility:
              'Deep green-black background guarantees high contrast for mint-white text; fireflies and bright foliage remain at borders.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as a mobile application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Sunny daytime, autumn yellow/red leaves, cartoon fairies, forest fires, animals, people, text, UI elements.',
        );

      case 'sunset':
        return const _ThemeProfileData(
          visualIdentity:
              'Warm twilight as golden hour collapses into deep dusk; warm amber, radiant cadmium orange, and molten coral highlights set against blackened terra cotta and volcanic charcoal shadows.',
          colorRoleGuidance:
              'Radiant sunset orange as a thin burning horizon line and rim-lit cloud edges; burnished amber as atmospheric haze and warm stone reflections; volcanic charcoal and deep ochre as expansive dark negative space.',
          colorDistribution:
              '68–72% volcanic charcoal & obsidian ochre, 18–22% burnt clay slate & burnished amber, 6–8% radiant sunset orange, 2–3% molten coral highlight.',
          mood:
              'Warm, nostalgic, luxurious, cinematic, reflective; 15 minutes post-sunset (golden hour fading into dusk). Winding down, accomplished.',
          lighting:
              'Low-angle horizontal sunset backlighting, warm amber rim lights hugging silhouettes, deep volcanic shadows in foreground with soft atmospheric haze.',
          atmosphere:
              'Lingering daytime warmth meeting cool evening breeze, calm accomplishment, rustic luxury, silent desert horizon.',
          materials:
              'Rammed earth, dark terracotta, warm dark leather, smoked bronze, polished dark travertine, desert sandstone, brushed brass.',
          environment:
              'Desert modern villa terrace, coastal cliff pavilion at dusk, canyon overlook, minimalist rooftop lounge looking toward the horizon.',
          visualMotifs:
              'Horizontal horizon gradient, layered mountain silhouettes, wispy cirrus cloud streaks, rim-lit architectural edges, dying solar glow.',
          artDirection:
              'Cinematic landscape photography (Denis Villeneuve aesthetic); rich atmospheric haze, wide anamorphic horizon feeling, painterly photorealistic gradients.',
          composition:
              'Vertical 9:16 mobile composition. Burning sky gradient in top 30%; receding mountain layers in upper-middle; bottom half fades into deep dark volcanic tones.',
          uiCompatibility:
              'Warm cream text offers pristine readability over dark burnt clay background; orange interactive accents match theme UI seamlessly.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as a mobile application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Midday bright sun, harsh blue skies, green grass, tiki bars, people, beachgoers, city clutter, text, UI elements.',
        );

      case 'pure_minimal':
        return const _ThemeProfileData(
          visualIdentity:
              'Architectural reduction, spatial elegance, and monoline restraint; deep graphite obsidian, precision titanium, and matte carbon slate punctuated by razor-sharp silver-white speculars.',
          colorRoleGuidance:
              'Precision silver as hairline architectural reveals and beveled edges; cold steel as subtle structural midtones; pure void black and obsidian graphite as absolute negative space.',
          colorDistribution:
              '76–80% pure void & obsidian graphite, 14–18% matte carbon & architectural slate, 4–6% precision silver, 1–2% specular platinum white.',
          mood:
              'Ultra-clean, disciplined, cerebral, silent, uncompromising; timeless architectural twilight / studio lighting. Zero friction, pure order.',
          lighting:
              'Extremely diffuse indirect architectural lighting; shadow reveals along recessed seams, perfectly uniform gradient falloffs with zero hot spots.',
          atmosphere:
              'Absolute clarity, Swiss design precision, zero friction, immaculate order, silent concrete gallery.',
          materials:
              'Brushed titanium, cast architectural concrete, matte black anodized aluminum, tinted float glass, smooth basalt.',
          environment:
              'Brutalist minimalist gallery, high-end industrial design studio, empty concrete observation deck, precision watchmaking cleanroom.',
          visualMotifs:
              'Clean rectilinear planes, 45-degree shadow angles, recessed reveal joints, subtle anisotropic metal brush textures, pure geometric voids.',
          artDirection:
              'Minimalist architectural photography meets high-end product design render; crisp orthogonal lines, perfectly controlled exposure, zero visual noise or film grain.',
          composition:
              'Vertical 9:16 mobile composition. Asymmetrical balance on strict grid lines; center 65% is an uninterrupted, uniform dark graphite field; structural edges stay at outer 15% margins.',
          uiCompatibility:
              'Zero visual friction; platinum text and titanium borders float over deep graphite with 100% clarity and zero chromatic aberration.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as a mobile application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Colors (no red, green, blue, yellow, orange), organic trees, plants, flowers, warm cozy lamps, people, grunge, text, UI elements.',
        );

      case 'aurora':
        return const _ThemeProfileData(
          visualIdentity:
              'Frozen sub-polar wilderness beneath an active ionospheric light display; ethereal ribbons of electric mint-teal and cosmic violet across a pitch polar night sky, reflecting off dark glacial ice and frozen obsidian fjords.',
          colorRoleGuidance:
              'Electric aurora teal on waving celestial light curtains; cosmic violet in upper atmospheric ionization; radiant cyan flare on bright curtain folds; sub-zero polar pitch on dark terrain and night sky.',
          colorDistribution:
              '70–75% sub-zero polar pitch & arctic abyss, 16–20% cosmic violet & glacial slate, 6–8% electric aurora teal, 2–3% vibrant cyan flare.',
          mood:
              'Cosmic, awe-inspiring, crystalline, visionary, serene; 01:00 AM polar night. Electric yet silent celestial dance.',
          lighting:
              'Primary light source is the celestial aurora borealis itself, casting soft teal and violet volumetric glow over dark landscape and reflective glacial ice.',
          atmosphere:
              'Electric yet silent, crystalline stillness, crisp sub-zero arctic air, visionary inspiration.',
          materials:
              'Glacial blue ice, volcanic black sand, dark basalt cliffs, crystalline frost, still fjord water, snow-dusted rock.',
          environment:
              'Frozen arctic fjord, black-sand beach with ice boulders, snowy mountain pass beneath celestial curtains, minimalist glass-domed polar observatory.',
          visualMotifs:
              'Waving auroral curtains (vertical light rays), distant snowy mountain spires, dark water reflections, celestial star fields, crystalline frost formations.',
          artDirection:
              'Long-exposure National Geographic night landscape photography meets cinematic sci-fi realism; sharp star pinpoints, smooth silky light curtains, hyper-crisp ice textures.',
          composition:
              'Vertical 9:16 mobile composition. Sweeping auroral curtains dominate top third; dark mountains or ice anchor bottom; central 45% is a calm, dark atmospheric zone.',
          uiCompatibility:
              'Deep arctic abyss background guarantees high contrast for crystalline white text; vibrant teal auroras stay high in the frame to prevent text wash-out.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as a mobile application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Daytime, green grass, tropical elements, city streetlights, people, tents with yellow lamps, text, UI elements.',
        );

      default:
        // Dynamic fallback for any custom or user-defined preset
        return _ThemeProfileData(
          visualIdentity:
              'A dark, premium, atmospheric mobile environment designed for focus and productivity, inspired by ${theme.name}.',
          colorRoleGuidance:
              'Primary and secondary colors provide subtle edge luminescence, environmental reflections, and focal highlights; deep background shades dominate the canvas.',
          colorDistribution:
              '70–75% deep dark background, 15–20% atmospheric surface midtones, 5–7% primary accent, 2–3% highlight.',
          mood: 'Contemplative, focused, modern, calm.',
          lighting:
              'Low-key cinematic lighting with controlled atmospheric glow and soft falloff.',
          atmosphere: 'Quiet, premium, clean, distraction-free.',
          materials: 'Glass, slate, brushed metal, atmospheric vapor.',
          environment: 'Architectural or landscape vista matching the theme mood.',
          visualMotifs: 'Atmospheric gradients, subtle geometry, soft light rays.',
          artDirection: 'Cinematic digital realism with clean exposure.',
          composition:
              'Vertical 9:16 framing with center 50% reserved for dark negative space to support mobile UI overlays.',
          uiCompatibility:
              'Designed to ensure maximum legibility for translucent glass cards and bright text.',
          imageRequirements:
              'Vertical mobile composition (9:16 aspect ratio). High-resolution environmental artwork designed as an application background. Controlled visual density, strong atmospheric depth, and UI-safe negative space. No text, typography, logos, UI, buttons, icons, or watermarks.',
          avoid:
              'Excessive saturation, chaotic visual noise, bright center hotspots, text, UI elements, watermarks.',
        );
    }
  }
}
