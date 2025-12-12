import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storageService = StorageService();
  String _temperatureUnit = 'metric';
  String _windSpeedUnit = 'm/s';
  String _timeFormat = '24h';
  String _themeMode = 'system';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final unit = await _storageService.getTemperatureUnit();
    final theme = await _storageService.getThemeMode();
    final windUnit = await _storageService.getWindSpeedUnit();
    final timeFormat = await _storageService.getTimeFormat();
    setState(() {
      _temperatureUnit = unit;
      _themeMode = theme;
      _windSpeedUnit = windUnit;
      _timeFormat = timeFormat;
    });
  }

  Future<void> _setTemperatureUnit(String unit) async {
    await _storageService.setTemperatureUnit(unit);
    setState(() {
      _temperatureUnit = unit;
    });
  }

  Future<void> _setWindSpeedUnit(String unit) async {
    await _storageService.setWindSpeedUnit(unit);
    setState(() {
      _windSpeedUnit = unit;
    });
  }

  Future<void> _setTimeFormat(String format) async {
    await _storageService.setTimeFormat(format);
    setState(() {
      _timeFormat = format;
    });
  }

  Future<void> _setThemeMode(String mode) async {
    await _storageService.setThemeMode(mode);
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Temperature Unit'),
          RadioListTile<String>(
            title: const Text('Celsius (°C)'),
            subtitle: const Text('Metric system'),
            value: 'metric',
            groupValue: _temperatureUnit,
            onChanged: (value) => _setTemperatureUnit(value!),
          ),
          RadioListTile<String>(
            title: const Text('Fahrenheit (°F)'),
            subtitle: const Text('Imperial system'),
            value: 'imperial',
            groupValue: _temperatureUnit,
            onChanged: (value) => _setTemperatureUnit(value!),
          ),
          const Divider(),
          _buildSectionHeader('Wind Speed Unit'),
          RadioListTile<String>(
            title: const Text('m/s'),
            subtitle: const Text('Meters per second'),
            value: 'm/s',
            groupValue: _windSpeedUnit,
            onChanged: (value) => _setWindSpeedUnit(value!),
          ),
          RadioListTile<String>(
            title: const Text('km/h'),
            subtitle: const Text('Kilometers per hour'),
            value: 'km/h',
            groupValue: _windSpeedUnit,
            onChanged: (value) => _setWindSpeedUnit(value!),
          ),
          RadioListTile<String>(
            title: const Text('mph'),
            subtitle: const Text('Miles per hour'),
            value: 'mph',
            groupValue: _windSpeedUnit,
            onChanged: (value) => _setWindSpeedUnit(value!),
          ),
          const Divider(),
          _buildSectionHeader('Time Format'),
          RadioListTile<String>(
            title: const Text('24-hour'),
            subtitle: const Text('Example: 14:30'),
            value: '24h',
            groupValue: _timeFormat,
            onChanged: (value) => _setTimeFormat(value!),
          ),
          RadioListTile<String>(
            title: const Text('12-hour'),
            subtitle: const Text('Example: 2:30 PM'),
            value: '12h',
            groupValue: _timeFormat,
            onChanged: (value) => _setTimeFormat(value!),
          ),
          const Divider(),
          _buildSectionHeader('Theme'),
          RadioListTile<String>(
            title: const Text('System'),
            subtitle: const Text('Follow system settings'),
            value: 'system',
            groupValue: _themeMode,
            onChanged: (value) => _setThemeMode(value!),
          ),
          RadioListTile<String>(
            title: const Text('Light'),
            value: 'light',
            groupValue: _themeMode,
            onChanged: (value) => _setThemeMode(value!),
          ),
          RadioListTile<String>(
            title: const Text('Dark'),
            value: 'dark',
            groupValue: _themeMode,
            onChanged: (value) => _setThemeMode(value!),
          ),
          const Divider(),
          _buildSectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('API Provider'),
            subtitle: Text('OpenWeatherMap'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

