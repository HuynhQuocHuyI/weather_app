import 'package:flutter/material.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildShimmerBox(200, 150),
          const SizedBox(height: 20),
          _buildShimmerBox(double.infinity, 150),
          const SizedBox(height: 20),
          _buildShimmerBox(double.infinity, 150),
          const SizedBox(height: 12),
          ...List.generate(5, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildShimmerBox(double.infinity, 60),
          )),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
