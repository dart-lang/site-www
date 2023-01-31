module Jekyll
  class DiagnosticPageGenerator < Jekyll::Generator
    def generate(site)
      diagnostics = site.data['diagnostics']
      cfe_messages = site.data['cfe_messages']

      new_info = {}

      diagnostics.each { |type, messages|
        messages.each { |name, info|
          name = name.downcase
          shared_name = info['sharedName']
          if shared_name != nil then
            shared_name = shared_name.downcase
            shared_info = new_info[shared_name]
            if shared_info != nil then
              shared_info['problemMessages'].append(info['problemMessage'])
              if shared_info['documentation'] == nil then
                shared_info['documentation'] = info['documentation']
              end
            else
              new_info[shared_name] = {
                'problemMessages' => [info['problemMessage']],
                'documentation' => info['documentation']
              }
            end
          else
            new_info[name] = {
              'problemMessages' => [info['problemMessage']],
              'documentation' => info['documentation']
            }
          end
        }
      }

      cfe_messages.each { |name, info|
        if info['documentation'] != nil then
          analyzer_name = info['analyzerCode'].gsub('ParserErrorCode.', '').downcase
          new_info[analyzer_name] = {
            'problemMessages' => [info['problemMessage']],
            'documentation' => info['documentation']
          }
        end
      }

      new_info.each { |name, info|
        site.pages << DiagnosticPage.new(site, name, info)
      }
    end
  end

  class DiagnosticPage < Jekyll::PageWithoutAFile
      def initialize(site, name, info)
        @site = site
        @base = site.source
        @dir  = "/tools/diagnostics"
        @basename = name
        @ext = '.md'
        @name = "#{name}.md"
        @content = "#{info['problemMessages'].map{|m| "_#{m}_"}.join("\n\n")}

#{info['documentation']&.gsub(/^####\s/, '### ')}

[constant context]: /tools/diagnostics#constant-context
[definite assignment]: /tools/diagnostics#definite-assignment
[mixin application]: /tools/diagnostics#mixin-application
[override inference]: /tools/diagnostics#override-inference
[part file]: /tools/diagnostics#part-file
[potentially non-nullable]: /tools/diagnostics#potentially-non-nullable
[public library]: /tools/diagnostics#public-library
[ffi]: /guides/libraries/c-interop
[meta-doNotStore]: https://pub.dev/documentation/meta/latest/meta/doNotStore-constant.html
[meta-factory]: https://pub.dev/documentation/meta/latest/meta/factory-constant.html
[meta-immutable]: https://pub.dev/documentation/meta/latest/meta/immutable-constant.html
[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[meta-literal]: https://pub.dev/documentation/meta/latest/meta/literal-constant.html
[meta-mustCallSuper]: https://pub.dev/documentation/meta/latest/meta/mustCallSuper-constant.html
[meta-optionalTypeArgs]: https://pub.dev/documentation/meta/latest/meta/optionalTypeArgs-constant.html
[meta-sealed]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html
[meta-useResult]: https://pub.dev/documentation/meta/latest/meta/useResult-constant.html
[meta-UseResult]: https://pub.dev/documentation/meta/latest/meta/UseResult-class.html
[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
[meta-visibleForTesting]: https://pub.dev/documentation/meta/latest/meta/visibleForTesting-constant.html
"

        @data = {
          'title' => name,
          'layout' => 'default'
        }

      end
    end
end
