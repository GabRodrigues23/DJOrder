import 'dart:async';
import 'package:djorder/core/utils/format_utils.dart';
import 'package:djorder/features/order/view/widgets/actions_button_widget.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:djorder/shared/mixins/menu_options_mixin.dart';
import 'package:flutter/material.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/settings/service/settings_service.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;
  final VoidCallback onTap;
  final VoidCallback? onChangeClient;

  const OrderItemWidget({
    super.key,
    required this.order,
    required this.onTap,
    this.onChangeClient,
  });

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget>
    with MenuOptionsMixin {
  Timer? _timer;
  String _timeText = '';
  Color _clockColor = Colors.white;
  bool focus = false;
  final _settings = SettingsService();

  @override
  void initState() {
    super.initState();
    _updateTimeAndSla();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateTimeAndSla();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _updateTimeAndSla() {
    final status = widget.order.calculatedStatus;

    if (status == OrderStatus.free) {
      _timeText = '';
      _clockColor = Colors.white;
      return;
    }

    final now = DateTime.now();
    final difference = now.difference(widget.order.oppeningDate);
    final minutesTotal = difference.inMinutes;

    final hours = difference.inHours.toString().padLeft(2, '0');
    final minutes = difference.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    _timeText = '$hours:$minutes';

    if (!_settings.isSlaEnables) {
      _clockColor = Colors.white;
      return;
    }
    if (minutesTotal >= _settings.criticalMinutes) {
      _clockColor = Colors.redAccent;
      return;
    }
    if (minutesTotal >= _settings.warningMinutes) {
      _clockColor = Colors.orangeAccent;
      return;
    }
    _clockColor = Colors.white;
  }

  bool updateFocus(focus) {
    return focus = !focus;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<OrderViewModel>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final status = widget.order.calculatedStatus;
        final bool showDetails = status != OrderStatus.free;
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: status.color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(2, 4),
                  color: Colors.black26,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  !showDetails
                      ? Center(
                          child: Text(
                            '#${widget.order.idOrder}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '#${widget.order.idOrder}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${widget.order.clientName}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Visibility(
                                visible:
                                    widget.order.idTable != null &&
                                    widget.order.idTable != 0,
                                child: Text(
                                  'Mesa: ${widget.order.idTable}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: _timeText.isNotEmpty
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (_timeText.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: _clockColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _timeText,
                                  style: TextStyle(
                                    color: _clockColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ActionsButtonWidget(
                          order: widget.order,
                          onSelected: (option) {
                            handleMenuAction(
                              context,
                              option,
                              widget.order,
                              viewModel,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Visibility(
                      visible: showDetails,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 4,
                            children: [
                              Text(
                                '${widget.order.peopleCount}',
                                style: TextStyle(color: Colors.black26),
                              ),
                              Icon(
                                Icons.people,
                                size: 20,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'R\$ ${FormatUtils.formatValue(widget.order.effectiveSubtotal.toStringAsFixed(2))}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
