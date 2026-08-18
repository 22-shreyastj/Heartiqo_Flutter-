import 'package:flutter/material.dart';


import '../../profile/model/profile_model.dart';

import 'profile_tag.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .76,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            _buildGradient(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      profile.image,
      fit: BoxFit.cover,

      errorBuilder: (_, _, _) {

        return Container(
          color: const Color(0xFFEEDFE1),
          child: const Icon(
            Icons.person,
            size: 80,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildGradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [
            0.35,
            0.65,
            1.0,
          ],
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: .08),
            Colors.black.withValues(alpha: .78),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      left: 22,
      right: 18,
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildName(),

          const SizedBox(height: 5),

          _buildDistance(),

          const SizedBox(height: 10),

          _buildMatchCompatibility(),

          const SizedBox(height: 10),

          Text(
            profile.bio,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 13),

          _buildTags(),
        ],
      ),
    );
  }

  Widget _buildMatchCompatibility() {
    if (profile.matchPercentage.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 13,
            color: Color(0xFFFFD700),
          ),
          const SizedBox(width: 5),
          Text(
            '${profile.matchPercentage} Match',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildName() {
    return Row(
      children: [
        Flexible(
          child: Text(
            profile.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),

        if (profile.verified) ...[
          const SizedBox(width: 7),
          const Icon(
            Icons.verified_rounded,
            size: 19,
            color: Color(0xFF4B8CF5),
          ),
        ],
      ],
    );
  }

  Widget _buildDistance() {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Colors.white,
        ),

        const SizedBox(width: 3),

        Text(
          profile.distance,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: profile.tags.length,


        separatorBuilder: (_, _) {

          return const SizedBox(width: 7);
        },
        itemBuilder: (context, index) {
          return ProfileTag(
            label: profile.tags[index],
            index: index,
          );
        },
      ),
    );
  }
}