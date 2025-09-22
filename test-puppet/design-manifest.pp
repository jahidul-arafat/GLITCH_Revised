class very_long_class_name_that_should_trigger_long_resource_smell_in_glitch_analysis_framework {
  # Long statement with complex logic
  if ($::operatingsystem == 'RedHat' and $::operatingsystemrelease >= '7.0' and $::architecture == 'x86_64' and $::memorysize_mb > 2048 and $::processorcount >= 2) {
    $complex_variable = "This is a very long string that contains multiple pieces of information and should trigger the long statement detection mechanism in GLITCH"
  }

  # Duplicate resource
  package { 'httpd':
    ensure => installed,
  }

  # Duplicate resource (exact same)
  package { 'httpd':
    ensure => installed,
  }

  # Misaligned resource
  package { 'nginx':
    ensure => installed,
  }

  # Too many variables
  $var1 = 'value1'
  $var2 = 'value2'
  $var3 = 'value3'
  $var4 = 'value4'
  $var5 = 'value5'
  $var6 = 'value6'
  $var7 = 'value7'
  $var8 = 'value8'
  $var9 = 'value9'
  $var10 = 'value10'
}