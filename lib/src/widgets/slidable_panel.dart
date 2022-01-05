// import 'package:flutter/material.dart';
// import 'package:gif_picker/src/widgets/slidable.dart';

// ///
// class SlidableGallery extends StatefulWidget {
//   ///
//   const SlidableGallery({
//     Key? key,
//     required this.child,
//     this.setting,
//   }) : super(key: key);

//   /// Child
//   final Widget child;

//   /// Panel setting
//   final SlideSetting? setting;

//   @override
//   State<SlidableGallery> createState() => _SlidableGalleryState();
// }

// class _SlidableGalleryState extends State<SlidableGallery> {
//   late final SlideController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = SlideController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       key: GlobalKey(),
//       child: SlideSettingBuilder(
//         setting: widget.setting,
//         builder: (panelSetting) {
//           final showPanel = MediaQuery.of(context).viewInsets.bottom == 0.0;
//           return Stack(
//             fit: StackFit.expand,
//             children: [
//               // Parent view
//               Column(
//                 children: [
//                   //
//                   Expanded(
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         final focusNode = FocusScope.of(context);
//                         if (focusNode.hasFocus) {
//                           focusNode.unfocus();
//                         }
//                         if (_controller.isVisible) {
//                           // _controller.completeTask(context);
//                         }
//                       },
//                       child: widget.child,
//                     ),
//                   ),

//                   // Space for panel min height
//                   // ValueListenableBuilder<bool>(
//                   //   valueListenable: _controller.panelVisibility,
//                   //   builder: (context, isVisible, child) {
//                   //     return SizedBox(
//                   //       height: showPanel && isVisible
//                   //           ? panelSetting.minHeight
//                   //           : 0.0,
//                   //     );
//                   //   },
//                   // ),

//                   //
//                 ],
//               ),

//               // Gallery
//               Slidable(
//                 setting: panelSetting,
//                 controller: _controller,
//                 child: Builder(
//                   // Builder is used here to pass accurate settings down
//                   // the tree
//                   builder: (_) => const SizedBox(),
//                 ),
//               ),

//               //
//             ],
//           );
//         },
//       ),
//     );

//     //
//   }
// }

// const _defaultMin = 0.37;

// ///
// class SlideSettingBuilder extends StatelessWidget {
//   ///
//   const SlideSettingBuilder({
//     Key? key,
//     required this.setting,
//     required this.builder,
//   }) : super(key: key);

//   ///
//   final SlideSetting? setting;

//   ///
//   final Widget Function(SlideSetting slideSetting) builder;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final mediaQuery = MediaQuery.of(context);
//         final size = constraints.biggest;
//         final isFullScreen = size.height == mediaQuery.size.height;
//         final ps = setting ?? const SlideSetting();
//         final _panelMaxHeight = ps.maxHeight ??
//             size.height - (isFullScreen ? mediaQuery.padding.top : 0);
//         final _panelMinHeight = ps.minHeight ?? _panelMaxHeight * _defaultMin;
//         final _setting = ps.copyWith(
//           maxHeight: _panelMaxHeight,
//           minHeight: _panelMinHeight,
//         );
//         return builder(_setting);
//       },
//     );
//   }
// }
